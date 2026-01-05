import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housely/features/property/domain/entities/property.dart';
import 'package:housely/features/property/domain/usecases/create_property.dart';
import 'package:housely/features/property/domain/usecases/delete_image_file.dart';
import 'package:housely/features/property/domain/usecases/update_image_file.dart';
import 'package:housely/features/property/domain/usecases/upload_cover_image.dart';
import 'package:housely/features/property/domain/usecases/upload_property_images.dart';

part 'property_state.dart';

class PropertyCubit extends Cubit<PropertyState> {
  final CreateProperty createProperty;
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
  }) : super(PropertyInitial());

  // upload cover image
  Future<Map<String, String>?> _uploadImage({
    required File image,
    required String folderType,
  }) async {
    emit(PropertyLoading());
    final param = UploadImageParam(image: image, folderType: folderType);
    final result = await uploadCoverImage(param);

    final uploaded = result.fold(
      (failure) {
        emit(PropertyError(failure.message));
        return null;
      },
      (imageUrl) {
        emit(CoverImageUploaded(imageUrl: imageUrl));
        return imageUrl;
      },
    );
    return uploaded;
  }

  // upload property images
  Future<Map<String, dynamic>?> _uploadImages({
    required List<File> images,
  }) async {
    emit(PropertyLoading());
    final param = UploadImagesParam(images: images);
    final result = await uploadPropertyImages(param);

    final uploadedImages = result.fold(
      (failure) {
        emit(PropertyError(failure.message));
        return null;
      },
      (imageUrl) {
        emit(GalleryImagesUploaded(imageListUrl: imageUrl));
        return imageUrl;
      },
    );

    return uploadedImages;
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

    if (coverUrl == null) return;

    final galleryUrl = await _uploadImages(images: images);

    if (galleryUrl == null) return;

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
}
