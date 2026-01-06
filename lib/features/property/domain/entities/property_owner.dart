class PropertyOwner {
  final String ownerId;
  final String name;
  final String phone;
  final Map<String, String>? profileImage;

  const PropertyOwner({
    required this.ownerId,
    required this.name,
    required this.phone,
    this.profileImage,
  });

  PropertyOwner copyWith({
    String? ownerId,
    String? name,
    String? phone,
    Map<String, String>? profileImage,
  }) {
    return PropertyOwner(
      ownerId: ownerId ?? this.ownerId,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      profileImage: profileImage ?? this.profileImage,
    );
  }
}
