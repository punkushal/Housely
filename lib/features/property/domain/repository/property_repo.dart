import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:housely/core/utils/typedef.dart';
import 'package:housely/features/property/domain/entities/property.dart';
import 'package:housely/features/property/domain/entities/property_filter_params.dart';

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

  // fetch all properties
  ResultFuture<List<Property>> fetchAllProperties();

  // search property and filter it
  ResultFuture<(List<Property> data, DocumentSnapshot? lastDoc)>
  searchPropertiesWithFilters({
    required PropertyFilterParams filters,
    DocumentSnapshot? lastDoc,
  });

  // update individual property
  ResultVoid updateProperty(Property property);

  // delete individual property
  ResultVoid deleteProperty(String propertyId);
}
