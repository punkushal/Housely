import 'dart:io';

import 'package:housely/core/utils/typedef.dart';
import 'package:housely/features/property/domain/entities/property_owner.dart';

abstract interface class OwnerRepo {
  // upload property cover image
  ResultFuture<Map<String, String>> uploadProfileImage({required File image});

  // create owner profile
  ResultVoid createOwnerProfile({required PropertyOwner owner});

  // fetch owner profile
  ResultFuture<PropertyOwner?> getOwnerProfile();
}
