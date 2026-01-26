// ignore_for_file: public_member_api_docs, sort_constructors_first
class AppUser {
  final String uid;
  final String email;
  final String username;
  final Map<String, dynamic>? photoUrl;

  AppUser({
    required this.uid,
    required this.email,
    required this.username,
    this.photoUrl,
  });

  AppUser copyWith({
    String? uid,
    String? email,
    String? username,
    Map<String, dynamic>? photoUrl,
  }) {
    return AppUser(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      username: username ?? this.username,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }
}
