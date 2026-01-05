import 'package:housely/features/property/domain/entities/property_owner.dart';

class PropertyOwnerModel extends PropertyOwner {
  PropertyOwnerModel({
    required super.ownerId,
    required super.name,
    required super.phone,
    super.profileImage,
  });

  // from firestore
  factory PropertyOwnerModel.fromJson(Map<String, dynamic> json) {
    return PropertyOwnerModel(
      ownerId: json['ownerId'],
      name: json['name'],
      phone: json['phone'],
      profileImage: json['profileImage'] ?? "no profile",
    );
  }

  // to firestore
  Map<String, String> toJson() => {
    'ownerId': ownerId,
    'name': name,
    'phone': phone,
    'profileImage': profileImage ?? "no profile",
  };

  PropertyOwnerModel copyWith({
    String? name,
    String? ownerId,
    String? profileImage,
    String? phone,
  }) {
    return PropertyOwnerModel(
      ownerId: ownerId ?? this.ownerId,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      profileImage: profileImage ?? this.profileImage,
    );
  }
}
