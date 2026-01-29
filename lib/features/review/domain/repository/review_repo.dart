import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
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

  /// delete review images
  ResultVoid deleteImageFile({required String fileId});

  /// Fetch all reviews
  ResultFuture<({List<Review> reviews, DocumentSnapshot? lastDoc})>
  getAllReviews({required String propertyId, DocumentSnapshot? lastDoc});

  /// Update review
  ResultVoid updateReview({
    required Review review,
    required String propertyId,
    required double oldRating,
  });

  /// Delete review
  ResultVoid deleteReview({
    required String reviewId,
    required String propertyId,
    required double ratingToDelete,
  });
}
