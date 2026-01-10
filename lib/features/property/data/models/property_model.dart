import 'package:housely/features/property/domain/entities/property.dart';
import 'package:housely/features/property/domain/entities/property_owner.dart';

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
    );
  }
}
