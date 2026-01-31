import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:housely/core/constants/text_constants.dart';
import 'package:housely/core/error/exception.dart';
import 'package:housely/core/utils/handle_error.dart';
import 'package:housely/features/auth/data/models/app_user_model.dart';
import 'package:housely/features/auth/domain/entities/app_user.dart';
import 'package:housely/features/property/data/models/property_owner_model.dart';
import 'package:housely/features/property/domain/entities/property_owner.dart';

class ProfileRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;

  ProfileRemoteDataSource({
    required this.firestore,
    required this.firebaseAuth,
  });

  Future<void> updateUserProfile({
    required AppUser appUser,
    PropertyOwner? owner,
  }) async {
    try {
      final userRef = firestore.collection(TextConstants.users);
      final ownerRef = firestore.collection(TextConstants.owners);

      final user = firebaseAuth.currentUser;
      final currentEmail = user!.email!;
      final userModel = AppUserModel.fromEntity(appUser);

      if (currentEmail != appUser.email) {
        await user.verifyBeforeUpdateEmail(appUser.email);
      }
      await userRef.doc(appUser.uid).update(userModel.toMap());

      if (owner != null) {
        final ownerModel = PropertyOwnerModel.fromEntity(owner);
        ownerRef.doc(appUser.email).update(ownerModel.toJson());
      }
    } on FirebaseAuthException catch (e) {
      handleFirebaseException(e);
    } on FirebaseException catch (e) {
      handleFirebaseError(e);
    } catch (e) {
      throw ServerException("Failed to update user profile");
    }
  }

  Future<void> reauthenticateUser(String password) async {
    try {
      final user = firebaseAuth.currentUser;

      if (user == null) {
        throw AuthException("User not authenticated");
      }

      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );

      await user.reauthenticateWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      handleFirebaseException(e);
    } catch (e) {
      throw AuthException("Failed to reauthenticate user: $e");
    }
  }
}
