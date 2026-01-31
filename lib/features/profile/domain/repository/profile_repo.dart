import 'package:housely/core/utils/typedef.dart';
import 'package:housely/features/auth/domain/entities/app_user.dart';
import 'package:housely/features/property/domain/entities/property_owner.dart';

abstract interface class ProfileRepo {
  /// update profile details
  ResultVoid updateUserProfile({
    required AppUser currentUser,
    PropertyOwner? currnetOwner,
  });

  /// reauthenticate user
  ResultVoid reauthenticateUser(String password);
}
