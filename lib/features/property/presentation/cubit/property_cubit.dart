import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housely/features/property/domain/entities/property.dart';
import 'package:housely/features/property/domain/usecases/create_property.dart';
import 'package:housely/features/property/domain/usecases/delete_image_file.dart';
import 'package:housely/features/property/domain/usecases/update_image_file.dart';
import 'package:housely/features/property/domain/usecases/update_property.dart';
import 'package:housely/features/property/domain/usecases/upload_cover_image.dart';
import 'package:housely/features/property/domain/usecases/upload_property_images.dart';

part 'property_state.dart';

class PropertyCubit extends Cubit<PropertyState> {
  final CreateProperty createProperty;
  final UpdateProperty updateProperty;
  final UploadCoverImage uploadCoverImage;
  final DeleteImageFile deleteImageFile;
  final UploadPropertyImages uploadPropertyImages;
  final UpdateImageFile updateImageFile;
  PropertyCubit({
    required this.uploadCoverImage,
    required this.uploadPropertyImages,
    required this.deleteImageFile,
    required this.createProperty,
    required this.updateImageFile,
    required this.updateProperty,
  }) : super(PropertyInitial());

  // upload cover image
  Future<Map<String, String>?> _uploadImage({
    required File image,
    required String folderType,
  }) async {
    final param = UploadImageParam(image: image, folderType: folderType);
    final result = await uploadCoverImage(param);

    return result.fold(
      (failure) {
        emit(PropertyError(failure.message));
        return null;
      },
      (imageUrl) {
        emit(CoverImageUploaded(imageUrl: imageUrl));
        return imageUrl;
      },
    );
  }

  // upload property images
  Future<Map<String, dynamic>?> _uploadImages({
    required List<File> images,
  }) async {
    final param = UploadImagesParam(images: images);
    final result = await uploadPropertyImages(param);
    return result.fold(
      (failure) {
        emit(PropertyError(failure.message));
        return null;
      },
      (imageUrl) {
        emit(GalleryImagesUploaded(imageListUrl: imageUrl));
        return imageUrl;
      },
    );
  }

  // deletes from appwrite and updates firestore to remove the link
  Future<void> deleteGalleryImage({
    required Property property,
    required String fileId,
  }) async {
    emit(PropertyLoading());

    // Deleting from Appwrite Storage
    final param = DeleteParam(fileId: fileId);
    final deleteResult = await deleteImageFile(param);

    await deleteResult.fold(
      (failure) async => emit(PropertyError(failure.message)),
      (_) async {
        // If storage delete success, remove from Property Object
        // Get current list safely
        final currentImages = List<Map<String, dynamic>>.from(
          property.media.gallery['images'] ?? [],
        );

        // Removing the item that matches the ID
        currentImages.removeWhere((img) => img['id'] == fileId);

        // Creating updated Property object
        final updatedProperty = property.copyWith(
          media: property.media.copyWith(gallery: {'images': currentImages}),
        );

        // Updating Firestore with the clean list
        final updateParam = UpdateParams(updatedProperty);
        final dbResult = await updateProperty(updateParam);

        dbResult.fold(
          (failure) => emit(PropertyError(failure.message)),
          (_) => emit(PropertyImageDeleted()),
        );
      },
    );
  }

  // upadte image
  Future<Map<String, String>?> updateImage({required String fileId}) async {
    emit(PropertyLoading());
    final param = UpdateParam(fileId: fileId);
    final result = await updateImageFile(param);

    final updatedImage = result.fold(
      (failure) {
        emit(PropertyError(failure.message));
        return null;
      },
      (imageUrl) {
        emit(PropertyImageUpdated(imageUrl: imageUrl));
        return imageUrl;
      },
    );

    return updatedImage;
  }

  // delete image file
  Future<void> deleteImage({required String fileId}) async {
    emit(PropertyLoading());

    final param = DeleteParam(fileId: fileId);

    final result = await deleteImageFile(param);

    result.fold(
      (failure) => emit(PropertyError(failure.message)),
      (_) => emit(PropertyImageDeleted()),
    );
  }

  // add new property
  Future<void> addProperty({
    required Property property,
    required File image,
    required List<File> images,
  }) async {
    emit(PropertyLoading());
    final coverUrl = await _uploadImage(image: image, folderType: "cover");

    if (coverUrl == null) {
      emit(PropertyInitial());
      return;
    }

    final galleryUrl = await _uploadImages(images: images);

    if (galleryUrl == null) {
      emit(PropertyInitial());
      return;
    }

    final result = await createProperty(
      CreateParam(
        property: property.copyWith(
          media: PropertyMedia(coverImage: coverUrl, gallery: galleryUrl),
        ),
      ),
    );

    result.fold(
      (failure) => emit(PropertyError(failure.message)),
      (_) => emit(PropertyCreated()),
    );
  }

  // update property details
  Future<void> updatePropertyDetails(
    Property property, {
    File? coverImage,
    List<File>? galleryImages,
  }) async {
    emit(PropertyLoading());
    Map<String, String>? updatedCoverUrl;
    List<dynamic> combinedGalleryList = [];

    // Upload new cover image if provided
    if (coverImage != null) {
      updatedCoverUrl = await _uploadImage(
        image: coverImage,
        folderType: "cover",
      );
      if (updatedCoverUrl == null) return;
    }

    // handling gallery images update
    // starting with existing images from the property
    if (property.media.gallery['images'] != null) {
      combinedGalleryList.addAll(property.media.gallery['images']);
    }

    //if new files exist, then upload them and append to list
    if (galleryImages != null && galleryImages.isNotEmpty) {
      final newUploadedMap = await _uploadImages(images: galleryImages);
      if (newUploadedMap == null) return; // upload failed

      if (newUploadedMap['images'] != null) {
        combinedGalleryList.addAll(newUploadedMap['images']);
      }
    }

    // Update property with new image URLs if they were uploaded
    final updatedProperty = property.copyWith(
      media: PropertyMedia(
        coverImage: updatedCoverUrl ?? property.media.coverImage,
        gallery: {'images': combinedGalleryList},
      ),
    );

    final param = UpdateParams(updatedProperty);
    final result = await updateProperty(param);

    result.fold(
      (failure) => emit(PropertyError(failure.message)),
      (_) => emit(PropertyUpdated()),
    );
  }
}
