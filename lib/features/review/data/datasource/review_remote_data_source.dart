import 'dart:io';

import 'package:appwrite/appwrite.dart' hide Query;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:housely/core/constants/text_constants.dart';
import 'package:housely/core/error/exception.dart';
import 'package:housely/features/review/data/models/review_model.dart';
import 'package:housely/features/review/domain/entity/review.dart';

import '../../../../env/env.dart';

class ReviewRemoteDataSource {
  final FirebaseFirestore firestore;
  final Storage storage;

  final _bucketId = Env.appWriteBucketId;
  final _projectId = Env.appWriteProjectId;
  ReviewRemoteDataSource({required this.storage, required this.firestore});

  Future<Map<String, String>> _uploadReviewImage({
    required File image,
    required String userEmail,
    required String folderType,
  }) async {
    try {
      final sanitizedEmail = userEmail.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_');
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = '${sanitizedEmail}_${folderType}_$timestamp';
      final file = await storage.createFile(
        bucketId: _bucketId,
        fileId: ID.unique(),
        file: InputFile.fromPath(path: image.path, filename: fileName),
        permissions: [Permission.read(Role.any())],
      );

      final fileUrl =
          '${TextConstants.appwriteUrl}/storage/buckets/$_bucketId/files/${file.$id}/view?project=$_projectId';

      return {"url": fileUrl, "id": file.$id};
    } catch (e) {
      throw ServerException("Failed to upload review image to appwrite : $e");
    }
  }

  Future<Map<String, dynamic>> uploadReviewImages({
    required List<File> images,
    required String userEmail,
  }) async {
    List<Map<String, dynamic>> galleryData = [];

    for (var image in images) {
      // we upload individual image and get all the list of urls
      final url = await _uploadReviewImage(
        image: image,
        userEmail: userEmail,
        folderType: "reviewImages",
      );
      galleryData.add(url);
    }

    return {"images": galleryData};
  }

  Future<void> deleteImageFile({required String fileId}) async {
    try {
      await storage.deleteFile(bucketId: _bucketId, fileId: fileId);
    } catch (e) {
      throw Exception("Failed to deleted review image file: $e");
    }
  }

  Future<void> addReview({
    required String propertyId,
    required Review review,
  }) async {
    try {
      final docRef = firestore
          .collection(TextConstants.properties)
          .doc(propertyId)
          .collection(TextConstants.reviewsCollection)
          .doc();
      final reviewModel = ReviewModel.fromEntity(review);

      final updateModel = reviewModel.copyWith(reviewId: docRef.id);

      await docRef.set(updateModel.toFireStore());
    } catch (e) {
      throw ServerException("Failed to add new review: $e");
    }
  }

  Future<void> updateReview({
    required String propertyId,
    required Review review,
  }) async {
    try {
      final docRef = firestore
          .collection(TextConstants.properties)
          .doc(propertyId)
          .collection(TextConstants.reviewsCollection)
          .doc(review.reviewId);
      final reviewModel = ReviewModel.fromEntity(review);

      await docRef.set(reviewModel.toFireStore(), SetOptions(merge: true));
    } catch (e) {
      throw ServerException("Failed to add update existing review: $e");
    }
  }

  Future<({DocumentSnapshot? lastDoc, List<Review> reviews})> getAllReviews({
    int limit = 10,
    required String propertyId,
    DocumentSnapshot? lastDoc,
  }) async {
    try {
      Query<Map<String, dynamic>> query = firestore
          .collection(TextConstants.properties)
          .doc(propertyId)
          .collection(TextConstants.reviewsCollection)
          .orderBy("createdAt");

      if (lastDoc != null) {
        query = query.startAfterDocument(lastDoc);
      }

      query = query.limit(limit);

      final snapshot = await query.get();
      final jsonList = snapshot.docs;

      final reviewList = jsonList
          .map((doc) => ReviewModel.fromFireStore(doc.data()))
          .toList();

      final newLastDoc = jsonList.isNotEmpty ? jsonList.last : null;

      return (reviews: reviewList, lastDoc: newLastDoc);
    } catch (e) {
      throw ServerException("Failed to fetch reviews: $e");
    }
  }
}
