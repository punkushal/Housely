import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fpdart/fpdart.dart';
import 'package:housely/core/error/failure.dart';
import 'package:housely/core/utils/handle_error.dart';
import 'package:housely/core/utils/typedef.dart';
import 'package:housely/features/review/data/datasource/review_remote_data_source.dart';
import 'package:housely/features/review/domain/entity/review.dart';
import 'package:housely/features/review/domain/repository/review_repo.dart';

class ReviewRepoImpl implements ReviewRepo {
  final ReviewRemoteDataSource remoteDataSource;

  ReviewRepoImpl(this.remoteDataSource);
  @override
  ResultVoid addReview({
    required Review review,
    required String propertyId,
  }) async {
    try {
      await remoteDataSource.addReview(propertyId: propertyId, review: review);
      return Right(null);
    } on FirebaseException catch (e) {
      return Left(handleFirebaseError(e));
    } catch (e) {
      return Left(ServerFailure("Failed to add new review :$e"));
    }
  }

  @override
  ResultFuture<Map<String, dynamic>> uploadReviewImages({
    required String userEmail,
    required List<File> images,
  }) async {
    try {
      final result = await remoteDataSource.uploadReviewImages(
        images: images,
        userEmail: userEmail,
      );

      return Right(result);
    } on AppwriteException catch (e) {
      return Left(handleAppWriteError(e));
    } catch (e) {
      return Left(ServerFailure("Failed to upload review images :$e"));
    }
  }

  @override
  ResultFuture<({DocumentSnapshot? lastDoc, List<Review> reviews})>
  getAllReviews({required String propertyId, DocumentSnapshot? lastDoc}) async {
    try {
      final result = await remoteDataSource.getAllReviews(
        propertyId: propertyId,
        lastDoc: lastDoc,
      );

      return Right(result);
    } on FirebaseException catch (e) {
      return Left(handleFirebaseError(e));
    } catch (e) {
      return Left(ServerFailure("Failed to fetch all the reviews :$e"));
    }
  }

  @override
  ResultVoid updateReview({
    required Review review,
    required String propertyId,
  }) async {
    try {
      await remoteDataSource.updateReview(
        propertyId: propertyId,
        review: review,
      );
      return Right(null);
    } on FirebaseException catch (e) {
      return Left(handleFirebaseError(e));
    } catch (e) {
      return Left(ServerFailure("Failed to update review :$e"));
    }
  }
}
