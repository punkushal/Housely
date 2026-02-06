import '../../domain/entities/app_user.dart';

class AppUserModel extends AppUser {
  AppUserModel({
    required super.uid,
    required super.email,
    required super.username,
    super.phoneNumber,
    super.fcmToken,
    super.profileImage,
  });

  factory AppUserModel.fromMap(Map<String, dynamic> map) {
    return AppUserModel(
      uid: map['userId'],
      email: map['email'],
      username: map['username'],
      phoneNumber: map['phoneNumber'],
      fcmToken: map['fcmToken'],
      profileImage: map['profileImage'],
    );
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = {
      'userId': uid,
      'email': email,
      'username': username,
      'phoneNumber': phoneNumber,
      'fcmToken': fcmToken,
    };

    if (profileImage != null) {
      map['profileImage'] = profileImage;
    }

    return map;
  }

  factory AppUserModel.fromEntity(AppUser appUser) {
    return AppUserModel(
      uid: appUser.uid,
      email: appUser.email,
      username: appUser.username,
      phoneNumber: appUser.phoneNumber,
      fcmToken: appUser.fcmToken,
      profileImage: appUser.profileImage,
    );
  }
}
