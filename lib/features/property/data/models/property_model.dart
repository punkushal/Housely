import 'package:housely/features/property/domain/entities/property.dart';
import 'package:housely/features/property/domain/entities/property_owner.dart';
import 'dart:convert';

class PropertyModel extends Property {
  PropertyModel({
    super.id,
    required super.name,
    required super.description,
    required super.owner,
    required super.location,
    required super.price,
    required super.status,
    required super.type,
    required super.specs,
    required super.media,
    required super.facilities,
    required super.createdAt,
    required super.updatedAt,
    required super.rating,
  });

  // FROM FIRESTORE
  factory PropertyModel.fromJson(Map<String, dynamic> json) {
    return PropertyModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      status: PropertyStatus.values.byName(json['status']),
      type: PropertyType.values.byName(json['type']),
      location: PropertyLocation(
        address: json['location']['address'],
        latitude: json['location']['latitude'],
        longitude: json['location']['longitude'],
      ),
      price: PropertyPrice(amount: (json['price']['amount'] as num).toDouble()),
      specs: PropertySpecs(
        area: (json['specs']['area'] as num).toDouble(),
        builtYear: json['specs']['builtYear'],
        bedrooms: json['specs']['bedrooms'],
        bathrooms: json['specs']['bathrooms'],
      ),
      media: PropertyMedia(
        coverImage: json['media']['coverImage'],
        gallery: json['media']['gallery'],
      ),
      facilities: List<String>.from(json['facilities']),
      owner: PropertyOwner(
        ownerId: json['owner']['ownerId'],
        name: json['owner']['name'],
        phone: json['owner']['phone'],
        profileImage: json['owner']['profileImage'],
      ),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      rating: PropertyRating(
        totalReviews: json['rating']['totalReviews'],
        averageRating: (json['rating']['averageRating'] as num).toDouble(),
      ),
    );
  }

  // TO FIRESTORE
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'status': status.name,
      'type': type.name,
      'location': {
        'address': location.address,
        'latitude': location.latitude,
        'longitude': location.longitude,
      },
      'price': {'amount': price.amount},
      'specs': {
        'area': specs.area,
        'builtYear': specs.builtYear,
        'bedrooms': specs.bedrooms,
        'bathrooms': specs.bathrooms,
      },
      'media': {'coverImage': media.coverImage, 'gallery': media.gallery},
      'facilities': facilities,
      'owner': {
        'ownerId': owner.ownerId,
        'name': owner.name,
        'phone': owner.phone,
        'profileImage': owner.profileImage,
      },

      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // FOR SQFLITE: Convert object to a flat Map with JSON strings
  Map<String, dynamic> toSqfliteMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'status': status.name,
      'type': type.name,
      'location': jsonEncode({
        'address': location.address,
        'latitude': location.latitude,
        'longitude': location.longitude,
      }),
      'price': jsonEncode({'amount': price.amount}),
      'specs': jsonEncode({
        'area': specs.area,
        'builtYear': specs.builtYear,
        'bedrooms': specs.bedrooms,
        'bathrooms': specs.bathrooms,
      }),
      'media': jsonEncode({
        'coverImage': media.coverImage,
        'gallery': media.gallery,
      }),
      'facilities': jsonEncode(facilities),
      'owner': jsonEncode({
        'ownerId': owner.ownerId,
        'name': owner.name,
        'phone': owner.phone,
        'profileImage': owner.profileImage,
      }),
      'rating': jsonEncode({
        'totalReviews': rating.totalReviews,
        'averageRating': rating.averageRating,
      }),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // FROM SQFLITE: Decode JSON strings back into objects
  factory PropertyModel.fromSqfliteMap(Map<String, dynamic> map) {
    // Helper to decode JSON strings safely
    Map<String, dynamic> decode(String key) => jsonDecode(map[key] ?? '{}');

    final locationData = decode('location');
    final priceData = decode('price');
    final specsData = decode('specs');
    final mediaData = decode('media');
    final ownerData = decode('owner');
    final ratingData = decode('rating');

    return PropertyModel(
      id: map['favorite_id'],
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      status: PropertyStatus.values.byName(map['status']),
      type: PropertyType.values.byName(map['type']),
      location: PropertyLocation(
        address: locationData['address'] ?? '',
        latitude: (locationData['latitude'] as num?)?.toDouble() ?? 0.0,
        longitude: (locationData['longitude'] as num?)?.toDouble() ?? 0.0,
      ),
      price: PropertyPrice(
        amount: (priceData['amount'] as num?)?.toDouble() ?? 0.0,
      ),
      specs: PropertySpecs(
        area: (specsData['area'] as num?)?.toDouble() ?? 0.0,
        builtYear: specsData['builtYear'] ?? '',
        bedrooms: specsData['bedrooms'] ?? 0,
        bathrooms: specsData['bathrooms'] ?? 0,
      ),
      media: PropertyMedia(
        coverImage: mediaData['coverImage'] ?? {},
        gallery: mediaData['gallery'] ?? {},
      ),
      facilities: List<String>.from(jsonDecode(map['facilities'] ?? '[]')),
      owner: PropertyOwner(
        ownerId: ownerData['ownerId'] ?? '',
        name: ownerData['name'] ?? '',
        phone: ownerData['phone'] ?? '',
        profileImage: ownerData['profileImage'],
      ),
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      rating: PropertyRating(
        totalReviews: ratingData['totalReviews'] ?? 0,
        averageRating: (ratingData['averageRating'] as num?)?.toDouble() ?? 0.0,
      ),
    );
  }

  factory PropertyModel.fromEntity(Property entity) => PropertyModel(
    id: entity.id,
    name: entity.name,
    description: entity.description,
    owner: entity.owner,
    location: entity.location,
    price: entity.price,
    status: entity.status,
    type: entity.type,
    specs: entity.specs,
    media: entity.media,
    facilities: entity.facilities,
    createdAt: entity.createdAt,
    updatedAt: entity.updatedAt,
    rating: entity.rating,
  );

  Property toEntity() => Property(
    name: name,
    description: description,
    owner: owner,
    location: location,
    price: price,
    status: status,
    type: type,
    specs: specs,
    media: media,
    facilities: facilities,
    createdAt: createdAt,
    updatedAt: updatedAt,
    rating: rating,
  );

  @override
  PropertyModel copyWith({
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
    PropertyRating? rating,
  }) {
    return PropertyModel(
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
      rating: rating ?? this.rating,
    );
  }
}
