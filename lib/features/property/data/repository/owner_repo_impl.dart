import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:housely/core/error/failure.dart';
import 'package:housely/core/utils/handle_error.dart';
import 'package:housely/core/utils/typedef.dart';
import 'package:housely/features/property/data/datasources/app_write_data_source.dart';
import 'package:housely/features/property/data/datasources/firebase_remote_data_source.dart';
import 'package:housely/features/property/data/models/property_owner_model.dart';
import 'package:housely/features/property/domain/entities/property_owner.dart';
import 'package:housely/features/property/domain/repository/owner_repo.dart';

class OwnerRepoImpl implements OwnerRepo {
  final FirebaseRemoteDataSource firebase;
  final AppwriteStorageDataSource dataSource;

  OwnerRepoImpl({required this.firebase, required this.dataSource});
  @override
  ResultVoid createOwnerProfile({required PropertyOwner owner}) async {
    try {
      final model = PropertyOwnerModel(
        ownerId: owner.ownerId,
        name: owner.name,
        phone: owner.phone,
        profileImage: owner.profileImage,
      );
      await firebase.createOwnerProfile(model);
      return Right(null);
    } on FirebaseAuthException catch (e) {
      return Left(handleFirebaseError(e));
    }
  }

  @override
  ResultFuture<PropertyOwner?> getOwnerProfile() async {
    try {
      final result = await firebase.getOwnerProfile();

      return Right(result);
    } on FirebaseAuthException catch (e) {
      return Left(handleFirebaseError(e));
    } catch (e) {
      return Left(UnknownFailure("Failed to fetch owner profile: $e"));
    }
  }

  @override
  ResultFuture<Map<String, String>> uploadProfileImage({
    required File image,
  }) async {
    try {
      final email = await firebase.getOwnerEmail();
      final result = await dataSource.uploadCoverImage(
        image: image,
        ownerEmail: email,
        folderType: "profile",
      );

      return Right(result);
    } on AppwriteException catch (e) {
      return Left(handleAppWriteError(e));
    } catch (e) {
      return Left(
        InvalidFileFailure("Failed to upload owner profile image: $e"),
      );
    }
  }
}
