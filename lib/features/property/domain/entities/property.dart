import 'package:housely/features/property/domain/entities/property_owner.dart';

/// Such as per month, per night etc
enum PriceUnit { night, month }

/// Either sale or rent
enum PropertyStatus { sale, rent }

/// Such as villa, hotel, house, etc.
enum PropertyType { villa, hotel, penthouse, apartment, house }

/// Property location details
class PropertyLocation {
  final String address;
  final double latitude;
  final double longitude;

  PropertyLocation({
    required this.address,
    required this.latitude,
    required this.longitude,
  });
}

/// Property pricing information
class PropertyPrice {
  final double amount;
  // final PriceUnit unit;

  PropertyPrice({required this.amount});
}

/// Property specifications
class PropertySpecs {
  final double area;
  final String builtYear;
  final int bedrooms;
  final int bathrooms;

  PropertySpecs({
    required this.area,
    required this.builtYear,
    required this.bedrooms,
    required this.bathrooms,
  });
}

/// Property media (images)
class PropertyMedia {
  final String coverImage;
  final List<String> gallery;

  PropertyMedia({required this.coverImage, required this.gallery});
}

class Property {
  final String id;
  final String name;
  final String description;
  final PropertyOwner owner;
  final PropertyLocation location;
  final PropertyPrice price;
  final PropertyStatus status;
  final PropertyType type;
  final PropertySpecs specs;
  final PropertyMedia media;
  final List<String> facilities;
  final DateTime createdAt;
  final DateTime updatedAt;

  Property({
    required this.id,
    required this.name,
    required this.description,
    required this.owner,
    required this.location,
    required this.price,
    required this.status,
    required this.type,
    required this.specs,
    required this.media,
    required this.facilities,
    required this.createdAt,
    required this.updatedAt,
  });
}
