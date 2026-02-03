import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housely/core/utils/file_utils.dart';
import 'package:housely/features/property/domain/entities/property.dart';
import 'package:housely/features/property/domain/usecases/create_property.dart';
import 'package:housely/features/property/domain/usecases/delete_image_file.dart';
import 'package:housely/features/property/domain/usecases/delete_property.dart';
import 'package:housely/features/property/domain/usecases/update_property.dart';
import 'package:housely/features/property/domain/usecases/upload_cover_image.dart';
import 'package:housely/features/property/domain/usecases/upload_property_images.dart';

import '../../../../../core/constants/app_limits.dart';

part 'property_crud_event.dart';
part 'property_crud_state.dart';

class PropertyCrudBloc extends Bloc<PropertyCrudEvent, PropertyCrudState> {
  final CreateProperty createProperty;
  final UpdateProperty updateProperty;
  final DeleteProperty deleteProperty;
  final UploadCoverImage uploadCoverImage;
  final UploadPropertyImages uploadPropertyImages;
  final DeleteImageFile deleteImageFile;

  PropertyCrudBloc({
    required this.createProperty,
    required this.updateProperty,
    required this.deleteProperty,
    required this.uploadCoverImage,
    required this.uploadPropertyImages,
    required this.deleteImageFile,
  }) : super(const PropertyCrudState()) {
    // Register event handlers
    on<PickCoverImage>(_onPickCoverImage);
    on<PickGalleryImages>(_onPickGalleryImages);
    on<RemoveLocalGalleryImage>(_onRemoveLocalGalleryImage);
    on<RemoveNetworkGalleryImage>(_onRemoveNetworkGalleryImage);
    on<LoadPropertyForEdit>(_onLoadPropertyForEdit);
    on<CreatePropertyEvent>(_onCreateProperty);
    on<UpdatePropertyEvent>(_onUpdateProperty);
    on<DeletePropertyEvent>(_onDeleteProperty);
    on<ResetPropertyCrud>(_onResetPropertyCrud);
  }

  // ============================================
  // IMAGE SELECTION HANDLERS
  // ============================================

  /// Handler for picking a cover image locally
  /// Simply stores the picked file in state for preview
  Future<void> _onPickCoverImage(
    PickCoverImage event,
    Emitter<PropertyCrudState> emit,
  ) async {
    final imageSize = FileUtils.getFileSizeInMB(event.image);
    if (imageSize <= 10) {
      return emit(state.copyWith(localCoverImage: event.image));
    } else {
      return emit(
        state.copyWith(
          errorMessage: "Cover image must be under 10 MB",
          status: .error,
        ),
      );
    }
  }

  /// Handler for picking multiple gallery images locally
  /// Adds them to the existing local gallery images list
  Future<void> _onPickGalleryImages(
    PickGalleryImages event,
    Emitter<PropertyCrudState> emit,
  ) async {
    final currentImages = List<File>.from(state.localGalleryImages);

    double currentSize = FileUtils.getTotalSizeInMB(currentImages);

    final allowedImages = <File>[];

    for (var image in event.images) {
      final imageSize = FileUtils.getFileSizeInMB(image);
      if (currentSize + imageSize <= maxPropertyImagesSizeInMB) {
        allowedImages.add(image);
        currentSize += imageSize;
      } else {
        break;
      }
    }

    if (allowedImages.isEmpty) {
      return emit(
        state.copyWith(
          status: .error,
          errorMessage: "Image files exceed $maxPropertyImagesSizeInMB MB",
        ),
      );
    }
    emit(
      state.copyWith(
        localGalleryImages: [...state.localGalleryImages, ...allowedImages],
        errorMessage: null,
      ),
    );
  }

  /// Handler for removing a local gallery image by index
  /// Simply removes it from the local list
  Future<void> _onRemoveLocalGalleryImage(
    RemoveLocalGalleryImage event,
    Emitter<PropertyCrudState> emit,
  ) async {
    final updatedList = List<File>.from(state.localGalleryImages);
    updatedList.removeAt(event.index);
    emit(state.copyWith(localGalleryImages: updatedList));
  }

  /// Handler for removing a network gallery image by index
  /// Marks it for deletion and removes from display list
  Future<void> _onRemoveNetworkGalleryImage(
    RemoveNetworkGalleryImage event,
    Emitter<PropertyCrudState> emit,
  ) async {
    final updatedUrls = List<String>.from(state.networkGalleryImageUrls);
    final removedUrl = updatedUrls.removeAt(event.index);

    // Extract the file ID from the URL to track for deletion
    final removedIds = List<String>.from(state.removedNetworkImageIds);

    removedIds.add(removedUrl); // This should be the file ID, not URL

    emit(
      state.copyWith(
        networkGalleryImageUrls: updatedUrls,
        removedNetworkImageIds: removedIds,
      ),
    );
  }

  // ============================================
  // PROPERTY LOADING HANDLER (for edit mode)
  // ============================================

  /// Handler for loading an existing property's data for editing
  /// Populates network images and stores the original property
  Future<void> _onLoadPropertyForEdit(
    LoadPropertyForEdit event,
    Emitter<PropertyCrudState> emit,
  ) async {
    final property = event.property;

    // Extract cover image URL
    final coverUrl = property.media.coverImage['url'] as String?;

    // Extract gallery image URLs
    final galleryList =
        property.media.gallery['images'] as List<dynamic>? ?? [];
    final galleryUrls = galleryList
        .map((img) => (img as Map<String, dynamic>)['url'] as String)
        .toList();

    emit(
      state.copyWith(
        originalProperty: property,
        networkCoverImageUrl: coverUrl,
        networkGalleryImageUrls: galleryUrls,
        // Clear any previous local selections
        localCoverImage: null,
        localGalleryImages: [],
        removedNetworkImageIds: [],
      ),
    );
  }

  // ============================================
  // CREATE PROPERTY HANDLER
  // ============================================

  /// Handler for creating a new property
  /// Steps: 1. Upload cover image, 2. Upload gallery images, 3. Create in Firestore
  Future<void> _onCreateProperty(
    CreatePropertyEvent event,
    Emitter<PropertyCrudState> emit,
  ) async {
    emit(state.copyWith(status: .loading, lastOperation: .create));

    Map<String, String>? coverImageData;
    Map<String, dynamic>? galleryData;

    // Upload cover image if exists
    if (state.localCoverImage != null) {
      final coverResult = await uploadCoverImage(
        UploadImageParam(image: state.localCoverImage!, folderType: 'cover'),
      );

      coverResult.fold(
        (failure) =>
            emit(state.copyWith(status: .error, errorMessage: failure.message)),
        (imageData) => coverImageData = imageData,
      );
    }

    // Upload gallery images if exist
    if (state.localGalleryImages.isNotEmpty) {
      final galleryResult = await uploadPropertyImages(
        UploadImagesParam(images: state.localGalleryImages),
      );

      galleryResult.fold(
        (failure) =>
            state.copyWith(status: .error, errorMessage: failure.message),
        (imageData) => galleryData = imageData,
      );
    }

    // Create property in Firestore with uploaded image URLs
    final propertyWithImages = event.property.copyWith(
      media: PropertyMedia(
        coverImage: coverImageData!,
        gallery: galleryData ?? {'images': []},
      ),
    );

    final createResult = await createProperty(
      CreateParam(property: propertyWithImages),
    );

    createResult.fold(
      (failure) =>
          emit(state.copyWith(status: .error, errorMessage: failure.message)),
      (_) => emit(state.copyWith(status: .success, lastOperation: .create)),
    );
  }

  // ============================================
  // UPDATE PROPERTY HANDLER
  // ============================================

  /// Handler for updating an existing property
  /// Steps: 1. Delete removed images, 2. Upload new images, 3. Update Firestore
  Future<void> _onUpdateProperty(
    UpdatePropertyEvent event,
    Emitter<PropertyCrudState> emit,
  ) async {
    emit(state.copyWith(status: .loading, lastOperation: .update));
    //Delete images that were removed from network gallery
    for (final imageId in state.removedNetworkImageIds) {
      await deleteImageFile(DeleteParam(fileId: imageId));
    }

    // Upload new cover image if user picked one
    Map<String, String>? updatedCoverData;
    if (state.localCoverImage != null) {
      // Delete old cover if exists
      if (state.originalProperty?.media.coverImage['id'] != null) {
        await deleteImageFile(
          DeleteParam(fileId: state.originalProperty!.media.coverImage['id']!),
        );
      }

      final coverResult = await uploadCoverImage(
        UploadImageParam(image: state.localCoverImage!, folderType: 'cover'),
      );

      coverResult.fold(
        (failure) =>
            emit(state.copyWith(status: .error, errorMessage: failure.message)),
        (imageData) => updatedCoverData = imageData,
      );
    }

    final originalGallery =
        state.originalProperty?.media.gallery['images'] as List<dynamic>? ?? [];

    final survivingGallery = originalGallery.where((item) {
      final map = item as Map<String, dynamic>;
      return state.networkGalleryImageUrls.contains(map['url']);
    }).toList();

    if (state.localGalleryImages.isNotEmpty) {
      final galleryResult = await uploadPropertyImages(
        UploadImagesParam(images: state.localGalleryImages),
      );

      galleryResult.fold(
        (failure) =>
            emit(state.copyWith(status: .error, errorMessage: failure.message)),
        (imageData) {
          final newImages = imageData['images'] as List<dynamic>? ?? [];
          survivingGallery.addAll(newImages);
        },
      );
    }

    // Update property in Firestore with new image URLs
    final updatedProperty = event.property.copyWith(
      media: event.property.media.copyWith(
        coverImage: updatedCoverData ?? event.property.media.coverImage,
        gallery: {'images': survivingGallery},
      ),
    );

    final updateResult = await updateProperty(UpdateParams(updatedProperty));

    updateResult.fold(
      (failure) =>
          emit(state.copyWith(status: .error, errorMessage: failure.message)),
      (_) => emit(state.copyWith(status: .success, lastOperation: .update)),
    );
  }

  // ============================================
  // DELETE PROPERTY HANDLER
  // ============================================

  /// Handler for deleting a property
  /// Steps: 1. Delete all images from Appwrite, 2. Delete property from Firestore
  Future<void> _onDeleteProperty(
    DeletePropertyEvent event,
    Emitter<PropertyCrudState> emit,
  ) async {
    emit(state.copyWith(status: .loading, lastOperation: .delete));

    final property = event.property;
    final List<String> fileIdsToDelete = [];

    // Add cover image ID
    if (property.media.coverImage.containsKey('id')) {
      fileIdsToDelete.add(property.media.coverImage['id']!);
    }

    // Add gallery image IDs
    final gallery = property.media.gallery['images'] as List<dynamic>? ?? [];
    for (var item in gallery) {
      if (item is Map && item.containsKey('id')) {
        fileIdsToDelete.add(item['id'].toString());
      }
    }

    // Delete all images from Appwrite in parallel for better performance
    await Future.wait(
      fileIdsToDelete.map((id) => deleteImageFile(DeleteParam(fileId: id))),
    );

    // Delete property from Firestore
    final deleteResult = await deleteProperty(
      DeletePropertyParam(property.id!),
    );

    deleteResult.fold(
      (failure) => emit(
        state.copyWith(
          status: PropertyCrudStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (_) => emit(
        state.copyWith(
          status: PropertyCrudStatus.success,
          lastOperation: PropertyOperation.delete,
        ),
      ),
    );
  }

  // ============================================
  // RESET HANDLER
  // ============================================

  /// Handler for resetting the bloc to initial state
  /// Used when navigating away from create/edit pages
  Future<void> _onResetPropertyCrud(
    ResetPropertyCrud event,
    Emitter<PropertyCrudState> emit,
  ) async {
    emit(const PropertyCrudState());
  }
}
