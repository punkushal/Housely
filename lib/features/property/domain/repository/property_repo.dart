import 'dart:io';

import 'package:housely/core/utils/typedef.dart';
import 'package:housely/features/property/domain/entities/property.dart';

abstract interface class PropertyRepo {
  // upload property images
  ResultFuture<Map<String, dynamic>> uploadPropertyImages({
    required List<File> images,
  });

  // upload property cover image
  ResultFuture<Map<String, String>> uploadCoverImage({
    required File image,
    required String folderType, // 'profile', 'cover', or 'gallery'
  });

  // delete property images
  ResultVoid deleteImageFile({required String fileId});

  // update image file and reture image url
  ResultFuture<Map<String, String>> updateImageFile({required String fileId});

  // add new property
  ResultVoid createProperty(Property property);
}
