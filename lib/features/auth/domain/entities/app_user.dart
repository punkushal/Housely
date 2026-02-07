// ignore_for_file: public_member_api_docs, sort_constructors_first
class AppUser {
  final String uid;
  final String email;
  final String username;
  final String? phoneNumber;
  final String? fcmToken;
  final Map<String, dynamic>? profileImage;

  AppUser({
    required this.uid,
    required this.email,
    required this.username,
    this.phoneNumber,
    this.fcmToken,
    this.profileImage,
  });

  AppUser copyWith({
    String? uid,
    String? email,
    String? username,
    String? phoneNumber,
    String? fcmToken,
    Map<String, dynamic>? profileImage,
  }) {
    return AppUser(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      username: username ?? this.username,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      fcmToken: fcmToken ?? this.fcmToken,
      profileImage: profileImage ?? this.profileImage,
    );
  }
}
