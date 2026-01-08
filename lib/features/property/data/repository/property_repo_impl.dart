import 'dart:io';
import 'package:appwrite/appwrite.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:housely/core/error/failure.dart';
import 'package:housely/core/utils/handle_error.dart';
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
      return Left(handleFirebaseError(e));
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
      return Left(handleAppWriteError(e));
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
      return Left(handleAppWriteError(e));
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
      return Left(handleAppWriteError(e));
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
      return Left(handleAppWriteError(e));
    } catch (e) {
      return Left(InvalidFileFailure("Failed to upload cover image: $e"));
    }
  }

  @override
  ResultFuture<List<Property>> fetchAllProperties() async {
    try {
      final result = await firebase.fetchAllProperties();
      return Right(result);
    } on FirebaseAuthException catch (e) {
      return Left(handleFirebaseError(e));
    } catch (e) {
      return Left(ServerFailure("An unexpected failure occur: $e"));
    }
  }

  @override
  ResultVoid updateProperty(Property property) async {
    final model = PropertyModel(
      id: property.id,
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
    try {
      await firebase.updateProperty(model);
      return Right(null);
    } on FirebaseAuthException catch (e) {
      return Left(handleFirebaseError(e));
    } catch (e) {
      return Left(
        ServerFailure(
          "An unexpected failure occur while updating the property: $e",
        ),
      );
    }
  }
}
