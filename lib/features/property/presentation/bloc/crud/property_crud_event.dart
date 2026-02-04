part of 'property_crud_bloc.dart';

sealed class PropertyCrudEvent extends Equatable {
  const PropertyCrudEvent();

  @override
  List<Object?> get props => [];
}

// ============================================
// IMAGE SELECTION EVENTS (local, before upload)
// ============================================

/// Event to pick a single cover image locally
class PickCoverImage extends PropertyCrudEvent {
  final File image;
  const PickCoverImage(this.image);

  @override
  List<Object?> get props => [image];
}

/// Event to pick multiple gallery images locally
class PickGalleryImages extends PropertyCrudEvent {
  final List<File> images;
  const PickGalleryImages(this.images);

  @override
  List<Object?> get props => [images];
}

/// Event to remove a local gallery image (by index)
class RemoveLocalGalleryImage extends PropertyCrudEvent {
  final int index;
  const RemoveLocalGalleryImage(this.index);

  @override
  List<Object?> get props => [index];
}

/// Event to remove a network gallery image (by index)
/// This only removes it from state temporarily — actual deletion happens on update/save
class RemoveNetworkGalleryImage extends PropertyCrudEvent {
  final int index;
  const RemoveNetworkGalleryImage(this.index);

  @override
  List<Object?> get props => [index];
}

// ============================================
// PROPERTY LOADING EVENTS (for edit mode)
// ============================================

/// Event to load an existing property's images for editing
class LoadPropertyForEdit extends PropertyCrudEvent {
  final Property property;
  const LoadPropertyForEdit(this.property);

  @override
  List<Object?> get props => [property];
}

// ============================================
// CRUD OPERATIONS
// ============================================

/// Event to create a new property
/// This uploads images first, then creates the property in Firestore
class CreatePropertyEvent extends PropertyCrudEvent {
  final Property property; // property data without image URLs yet
  const CreatePropertyEvent(this.property);

  @override
  List<Object?> get props => [property];
}

/// This fetches property from firestore when it's data updated
class LoadNetworkPropertyEvent extends PropertyCrudEvent {
  final String propertyId;

  const LoadNetworkPropertyEvent(this.propertyId);

  @override
  List<Object?> get props => [propertyId];
}

/// Event to update an existing property
/// This handles deletion of removed images, upload of new images, and update in Firestore
class UpdatePropertyEvent extends PropertyCrudEvent {
  final Property property; // updated property data
  const UpdatePropertyEvent(this.property);

  @override
  List<Object?> get props => [property];
}

/// Event to delete a property
/// This deletes all images from Appwrite and the property from Firestore
class DeletePropertyEvent extends PropertyCrudEvent {
  final Property property;
  const DeletePropertyEvent(this.property);

  @override
  List<Object?> get props => [property];
}

// ============================================
// UTILITY EVENTS
// ============================================

/// Event to reset the bloc to initial state
class ResetPropertyCrud extends PropertyCrudEvent {
  const ResetPropertyCrud();
}
