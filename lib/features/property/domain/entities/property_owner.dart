class PropertyOwner {
  final String ownerId;
  final String name;
  final String phone;
  final String? profileImage;

  const PropertyOwner({
    required this.ownerId,
    required this.name,
    required this.phone,
    this.profileImage,
  });
}
