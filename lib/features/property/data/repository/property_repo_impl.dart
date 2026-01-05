import 'dart:io';
import 'package:appwrite/appwrite.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:housely/core/error/failure.dart';
import 'package:housely/core/utils/typedef.dart';
import 'package:housely/features/property/data/datasources/app_write_data_source.dart';
import 'package:housely/features/property/data/datasources/firebase_remote_data_source.dart';
import 'package:housely/features/property/data/models/property_model.dart';
import 'package:housely/features/property/domain/entities/property.dart';
import 'package:housely/features/property/domain/repository/property_repo.dart';

class PropertyRepoImpl implements PropertyRepo {
  final AppwriteStorageDataSource dataSource;
  final FirebaseRemoteDataSource firebase;

  PropertyRepoImpl({required this.dataSource, required this.firebase});
  @override
  ResultVoid createProperty(Property property) async {
    try {
      final model = PropertyModel(
        id: "",
        name: property.name,
        description: property.description,
        owner: property.owner,
        location: property.location,
        price: property.price,
        status: property.status,
        type: property.type,
        specs: property.specs,
        media: property.media,
        facilities: property.facilities,
        createdAt: property.createdAt,
        updatedAt: property.updatedAt,
      );
      await firebase.addNewProperty(model);
      return Right(null);
    } on FirebaseAuthException catch (e) {
      return Left(_handleFirebaseError(e));
    } catch (e) {
      return Left(ServerFailure("An unexpected failure occur: $e"));
    }
  }

  @override
  ResultVoid deleteImageFile({required String fileId}) async {
    try {
      await dataSource.deleteImageFile(fileId: fileId);
      return Right(null);
    } on AppwriteException catch (e) {
      return Left(_handleError(e));
    } catch (e) {
      return Left(InvalidFileFailure("Failed to deleted image file: $e"));
    }
  }

  @override
  ResultFuture<Map<String, String>> updateImageFile({
    required String fileId,
  }) async {
    try {
      final result = await dataSource.updateImageFile(fileId: fileId);
      return Right(result);
    } on AppwriteException catch (e) {
      return Left(_handleError(e));
    } catch (e) {
      return Left(InvalidFileFailure("Failed to update image file: $e"));
    }
  }

  @override
  ResultFuture<Map<String, String>> uploadCoverImage({
    required File image,
    required String folderType,
  }) async {
    try {
      final email = await firebase.getOwnerEmail();
      final result = await dataSource.uploadCoverImage(
        image: image,
        ownerEmail: email,
        folderType: folderType,
      );
      return Right(result);
    } on AppwriteException catch (e) {
      return Left(_handleError(e));
    } catch (e) {
      return Left(InvalidFileFailure("Failed to upload cover image: $e"));
    }
  }

  @override
  ResultFuture<Map<String, dynamic>> uploadPropertyImages({
    required List<File> images,
  }) async {
    try {
      final email = await firebase.getOwnerEmail();
      final result = await dataSource.uploadPropertyImages(
        images: images,
        ownerEmail: email,
      );
      return Right(result);
    } on AppwriteException catch (e) {
      return Left(_handleError(e));
    } catch (e) {
      return Left(InvalidFileFailure("Failed to upload cover image: $e"));
    }
  }

  /// Centralized Error Handling
  Failure _handleFirebaseError(FirebaseException e) {
    switch (e.code) {
      case 'permission-denied':
        return PermissionFailure(
          "You don't have permission to save this data. Check your Security Rules.",
        );
      case 'resource-exhausted':
        return ResourceExceedFailure("Quota exceeded. Please try again later.");
      case 'unavailable':
        return NetworkFailure(
          "The service is currently unavailable. Check your internet connection.",
        );
      case 'deadline-exceeded':
        return DeadlineExceedFailure(
          "The request took too long. Try a smaller data payload.",
        );
      default:
        return UnknownFailure("Firestore Error [${e.code}]: ${e.message}");
    }
  }

  Failure _handleError(AppwriteException e) {
    // Appwrite uses numerical codes (404, 401, 429) and string types
    switch (e.type) {
      case 'user_unauthorized':
        return UnauthorizedFailure(
          "Error: Check your Bucket permissions in Appwrite Console.",
        );

      case 'storage_file_not_found':
        return InvalidFileFailure(
          "Error: The file you are trying to delete/access is gone.",
        );

      default:
        return InvalidFileFailure("Appwrite Error (${e.code}): ${e.message}");
    }
  }
}
