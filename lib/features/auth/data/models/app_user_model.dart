import 'package:housely/features/auth/domain/entities/app_user.dart';

class AppUserModel extends AppUser {
  AppUserModel({
    required super.uid,
    required super.email,
    required super.username,
    super.phoneNumber,
    super.photoUrl,
  });

  factory AppUserModel.fromMap(Map<String, dynamic> map) {
    return AppUserModel(
      uid: map['userId'],
      email: map['email'],
      username: map['username'],
      phoneNumber: map['phoneNumber'],
      photoUrl: map['photoUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = {
      'userId': uid,
      'email': email,
      'username': username,
      'phoneNumber': phoneNumber,
    };

    if (photoUrl != null) {
      map['photoUrl'] = photoUrl;
    }

    return map;
  }

  factory AppUserModel.fromEntity(AppUser appUser) {
    return AppUserModel(
      uid: appUser.uid,
      email: appUser.email,
      username: appUser.username,
      phoneNumber: appUser.phoneNumber,
      photoUrl: appUser.photoUrl,
    );
  }
}
