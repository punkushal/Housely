import 'dart:io';

import 'package:housely/core/utils/typedef.dart';
import 'package:housely/features/property/domain/entities/property.dart';

abstract interface class PropertyRepo {
  // upload property images
  ResultFuture<List<String>> uploadPropertyImages(List<File> images);

  // upload property cover image
  ResultFuture<String> uploadCoverImage(File image);

  // delete property images
  ResultVoid deleteImageFile({
    required String bucketId,
    required String fileId,
  });

  // update image file and reture image url
  ResultFuture<String> updateImageFile({
    required String bucketId,
    required String fileId,
  });

  // add new property
  ResultVoid createProperty(Property property);
}
