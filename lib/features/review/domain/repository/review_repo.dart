import 'dart:io';

import 'package:housely/core/utils/typedef.dart';
import 'package:housely/features/review/domain/entity/review.dart';

abstract interface class ReviewRepo {
  /// Add review
  ResultVoid addReview({required Review review, required String propertyId});

  /// Upload review images
  ResultFuture<Map<String, dynamic>> uploadReviewImages({
    required String userEmail,
    required List<File> images,
  });
}
