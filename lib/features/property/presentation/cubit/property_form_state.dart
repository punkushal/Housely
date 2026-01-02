part of 'property_form_cubit.dart';

class PropertyFormState {
  final String? propertyType;
  final String? propertyStatus;
  final File? image;
  final List<File> imageList;
  final String? imageError;

  PropertyFormState({
    this.propertyType,
    this.image,
    this.imageList = const [],
    this.propertyStatus,
    this.imageError,
  });

  PropertyFormState copyWith({
    String? propertyType,
    String? propertyStatus,
    String? imageError,
    File? image,
    List<File>? imageList,
  }) {
    return PropertyFormState(
      propertyType: propertyType ?? this.propertyType,
      propertyStatus: propertyStatus ?? this.propertyStatus,
      image: image ?? this.image,
      imageList: imageList ?? this.imageList,
      imageError: imageError ?? this.imageError,
    );
  }
}
