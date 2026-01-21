import 'package:housely/features/auth/domain/entities/app_user.dart';

class AppUserModel extends AppUser {
  AppUserModel({
    required super.uid,
    required super.email,
    required super.username,
    super.photoUrl,
  });

  factory AppUserModel.fromMap(Map<String, dynamic> map) {
    return AppUserModel(
      uid: map['userId'],
      email: map['email'],
      username: map['username'],
      photoUrl: map['photoUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': uid,
      'email': email,
      'username': username,
      'photoUrl': photoUrl,
    };
  }

  factory AppUserModel.fromEntity(AppUser appUser) {
    return AppUserModel(
      uid: appUser.uid,
      email: appUser.email,
      username: appUser.username,
      photoUrl: appUser.photoUrl,
    );
  }
}
