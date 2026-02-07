part of 'property_form_cubit.dart';

class PropertyFormState {
  final String? propertyType;
  final String? propertyStatus;
  final File? image;
  final List<File> imageList;
  final List<String> facilities;
  final List<Map<String, dynamic>> existingNetworkImages;
  final String? imageError;
  final String? address;
  final String? year;

  PropertyFormState({
    this.propertyType,
    this.image,
    this.imageList = const [],
    this.facilities = const [],
    this.existingNetworkImages = const [],
    this.propertyStatus,
    this.imageError,
    this.address,
    this.year,
  });

  PropertyFormState copyWith({
    String? propertyType,
    String? propertyStatus,
    String? imageError,
    File? image,
    List<File>? imageList,
    List<String>? facilities,
    List<Map<String, dynamic>>? existingNetworkImages,
    String? address,
    String? year,
  }) {
    return PropertyFormState(
      propertyType: propertyType ?? this.propertyType,
      propertyStatus: propertyStatus ?? this.propertyStatus,
      image: image ?? this.image,
      imageList: imageList ?? this.imageList,
      imageError: imageError ?? this.imageError,
      facilities: facilities ?? this.facilities,
      existingNetworkImages:
          existingNetworkImages ?? this.existingNetworkImages,
      address: address ?? this.address,
      year: year ?? this.year,
    );
  }
}
