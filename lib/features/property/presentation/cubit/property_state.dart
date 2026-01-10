part of 'property_cubit.dart';

sealed class PropertyState extends Equatable {
  const PropertyState();

  @override
  List<Object> get props => [];
}

final class PropertyInitial extends PropertyState {}

final class PropertyLoading extends PropertyState {}

final class GalleryImagesUploaded extends PropertyState {
  final Map<String, dynamic> imageListUrl;

  const GalleryImagesUploaded({required this.imageListUrl});
}

final class CoverImageUploaded extends PropertyState {
  final Map<String, String> imageUrl;

  const CoverImageUploaded({required this.imageUrl});
}

final class PropertyCreated extends PropertyState {}

final class PropertyUpdated extends PropertyState {}

final class PropertyImageDeleted extends PropertyState {}

final class PropertyImageUpdated extends PropertyState {
  final Map<String, String> imageUrl;

  const PropertyImageUpdated({required this.imageUrl});
}

final class PropertyError extends PropertyState {
  final String message;

  const PropertyError(this.message);
}
