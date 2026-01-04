/// Such as per month, per night etc
enum PriceUnit { night, month }

/// Either sale or rent
enum PropertyStatus { sale, rent }

/// Such as villa , hotel, house , etc.
enum PropertyType { villa, hotel, penthouse, apartment, house }

/// Such as sqft, sqm
enum AreaUnit { sqft, sqm }

class Property {
  final String name;
  final String description;
  final String location;
  final double price;
  final PriceUnit priceUnit;
  final double rating;
  final bool isFavorite;
  final PropertyStatus status;
  final double area;
  final String builtYear;
  final int numberOfbathTub;
  final int numberOfbedroom;
  final PropertyType propertyType;
  final String coverImgUrl;
  final List<String> galleryImgUrls;
  final List<String> facilities;
  final DateTime createdAt;
  final DateTime updatedAt;
  final AreaUnit areaUnit;

  Property({
    required this.name,
    required this.description,
    required this.location,
    required this.price,
    required this.priceUnit,
    required this.rating,
    required this.status,
    required this.area,
    required this.builtYear,
    required this.numberOfbathTub,
    required this.numberOfbedroom,
    required this.propertyType,
    required this.coverImgUrl,
    required this.galleryImgUrls,
    required this.facilities,
    required this.createdAt,
    required this.updatedAt,
    this.isFavorite = false,
    required this.areaUnit,
  });
}
