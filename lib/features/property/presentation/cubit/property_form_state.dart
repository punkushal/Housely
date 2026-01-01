part of 'property_form_cubit.dart';

class PropertyFormState {
  final String? propertyType;
  final String? propertyStatus;
  final File? image;
  final List<File> imageList;

  PropertyFormState({
    this.propertyType,
    this.image,
    this.imageList = const [],
    this.propertyStatus,
  });

  PropertyFormState copyWith({
    String? propertyType,
    String? propertyStatus,
    File? image,
    List<File>? imageList,
  }) {
    return PropertyFormState(
      propertyType: propertyType ?? this.propertyType,
      propertyStatus: propertyStatus ?? this.propertyStatus,
      image: image ?? this.image,
      imageList: imageList ?? this.imageList,
    );
  }
}
