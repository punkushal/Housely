// ignore_for_file: public_member_api_docs, sort_constructors_first
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
  final Map<String, dynamic> coverImage;
  final Map<String, dynamic> gallery;

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

  Property copyWith({
    String? id,
    String? name,
    String? description,
    PropertyOwner? owner,
    PropertyLocation? location,
    PropertyPrice? price,
    PropertyStatus? status,
    PropertyType? type,
    PropertySpecs? specs,
    PropertyMedia? media,
    List<String>? facilities,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Property(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      owner: owner ?? this.owner,
      location: location ?? this.location,
      price: price ?? this.price,
      status: status ?? this.status,
      type: type ?? this.type,
      specs: specs ?? this.specs,
      media: media ?? this.media,
      facilities: facilities ?? this.facilities,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
