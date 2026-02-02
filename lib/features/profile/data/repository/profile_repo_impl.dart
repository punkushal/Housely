import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:housely/core/error/failure.dart';
import 'package:housely/core/utils/handle_error.dart';
import 'package:housely/core/utils/typedef.dart';
import 'package:housely/features/auth/domain/entities/app_user.dart';
import 'package:housely/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:housely/features/profile/domain/repository/profile_repo.dart';
import 'package:housely/features/property/data/datasources/app_write_data_source.dart';
import 'package:housely/features/property/domain/entities/property_owner.dart';

class ProfileRepoImpl implements ProfileRepo {
  final ProfileRemoteDataSource remoteDataSource;
  final AppwriteStorageDataSource storageDataSource;
  ProfileRepoImpl({
    required this.remoteDataSource,
    required this.storageDataSource,
  });

  @override
  ResultVoid updateUserProfile({
    required AppUser currentUser,
    PropertyOwner? currnetOwner,
  }) async {
    try {
      await remoteDataSource.updateUserProfile(
        appUser: currentUser,
        owner: currnetOwner,
      );

      return Right(null);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        return Left(ServerFailure('requires-recent-login'));
      }
      return Left(ServerFailure(e.message ?? "Email update failed"));
    } catch (e) {
      return Left(
        ServerFailure("Failed to update user profile: ${e.toString()}"),
      );
    }
  }

  @override
  ResultFuture<Map<String, String>> uploadProfileImage({
    required File image,
    required String folderType,
    required String email,
  }) async {
    try {
      final result = await storageDataSource.uploadCoverImage(
        image: image,
        ownerEmail: email,
        folderType: folderType,
      );

      return Right(result);
    } on AppwriteException catch (e) {
      return Left(handleAppWriteError(e));
    } catch (e) {
      return Left(InvalidFileFailure("Failed to upload cover image: $e"));
    }
  }

  @override
  ResultVoid deleteProfileImage({required String fileId}) async {
    try {
      await storageDataSource.deleteImageFile(fileId: fileId);
      return Right(null);
    } on AppwriteException catch (e) {
      return Left(handleAppWriteError(e));
    } catch (e) {
      return Left(InvalidFileFailure("Failed to delete profile image: $e"));
    }
  }
}
