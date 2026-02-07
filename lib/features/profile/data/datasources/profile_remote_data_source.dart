import 'package:appwrite/appwrite.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:housely/core/constants/text_constants.dart';
import 'package:housely/core/error/exception.dart';
import 'package:housely/core/utils/handle_error.dart';
import 'package:housely/features/auth/data/models/app_user_model.dart';
import 'package:housely/features/auth/domain/entities/app_user.dart';
import 'package:housely/features/property/data/datasources/app_write_data_source.dart';
import 'package:housely/features/property/data/models/property_owner_model.dart';
import 'package:housely/features/property/domain/entities/property_owner.dart';

class ProfileRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;
  final AppwriteStorageDataSource appwriteStorageDataSource;

  ProfileRemoteDataSource({
    required this.firestore,
    required this.firebaseAuth,
    required this.appwriteStorageDataSource,
  });

  Future<void> updateUserProfile({
    required AppUser appUser,
    PropertyOwner? owner,
  }) async {
    try {
      final userRef = firestore.collection(TextConstants.users);
      final ownerRef = firestore.collection(TextConstants.owners);

      final userModel = AppUserModel.fromEntity(appUser);

      // update user profile
      await userRef.doc(appUser.uid).update(userModel.toMap());

      // If user has a name and phone number, sync with owner collection
      if (appUser.username.isNotEmpty &&
          appUser.phoneNumber != null &&
          appUser.phoneNumber!.isNotEmpty) {
        final ownerModel = PropertyOwnerModel(
          ownerId: appUser.uid,
          name: appUser.username,
          phone: appUser.phoneNumber!,
          profileImage: appUser.profileImage,
        );

        // upsert (merge: true will create if not exists, update if exists)
        await ownerRef
            .doc(appUser.email)
            .set(ownerModel.toJson(), SetOptions(merge: true));
      }
    } on FirebaseAuthException catch (e) {
      handleFirebaseException(e);
    } on FirebaseException catch (e) {
      handleFirebaseError(e);
    } catch (e) {
      throw ServerException("Failed to update user profile");
    }
  }

  Future<void> deleteProfileImage({required String fileId}) async {
    try {
      await appwriteStorageDataSource.deleteImageFile(fileId: fileId);
    } on AppwriteException catch (e) {
      handleAppWriteError(e);
    } catch (e) {
      throw ServerException("Failed to delete profile image: $e");
    }
  }
}
