import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:housely/core/constants/text_constants.dart';
import 'package:housely/core/error/exception.dart';
import 'package:housely/core/utils/handle_error.dart';
import 'package:housely/features/auth/data/models/app_user_model.dart';
import 'package:housely/features/auth/domain/entities/app_user.dart';

abstract class AuthRemoteDataSource {
  Future<void> register({
    required String username,
    required String email,
    required String password,
  });

  Future<void> login({required String email, required String password});

  Future<void> logout();

  Future<AppUser?> googleSignIn();

  Future<void> sendPasswordRestEmail({required String email});

  Stream<AppUser?> get authStateChanges;

  bool isLoggedIn();

  Future<AppUser?> getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final GoogleSignIn googleSignInInstance;
  final FirebaseFirestore firestore;

  AuthRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.googleSignInInstance,
    required this.firestore,
  });

  /// login through firebase auth
  @override
  Future<void> login({required String email, required String password}) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw handleFirebaseException(e);
    } catch (e) {
      throw ServerException('An unexpected error occurred');
    }
  }

  /// logout through firebase auth
  @override
  Future<void> logout() async {
    try {
      await firebaseAuth.signOut();
    } catch (e) {
      throw ServerException('Failed to logout');
    }
  }

  /// register through firebase auth
  @override
  Future<void> register({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = AppUserModel(
        uid: userCredential.user!.uid,
        email: email,
        username: username,
      );
      await firestore
          .collection('users')
          .doc(user.uid)
          .set(user.toMap(), SetOptions(merge: true));

      // Update display name
      await userCredential.user?.updateDisplayName(username);
    } on FirebaseAuthException catch (e) {
      throw handleFirebaseException(e);
    } catch (e) {
      throw ServerException('An unexpected error occurred');
    }
  }

  @override
  Future<AppUser?> googleSignIn() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount googleUser = await googleSignInInstance
          .authenticate();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      // sign in with these credential
      final userCredential = await firebaseAuth.signInWithCredential(
        credential,
      );

      // firebase user
      final firebaseUser = userCredential.user;

      // user cancelled sign-in process
      if (firebaseUser == null) return null;

      final appUser = AppUser(
        uid: firebaseUser.uid,
        email: firebaseUser.email!,
        username: firebaseUser.displayName!,
      );

      final user = AppUserModel.fromEntity(appUser);

      await firestore
          .collection('users')
          .doc(user.uid)
          .set(user.toMap(), SetOptions(merge: true));

      return appUser;
    } on FirebaseAuthException catch (e) {
      throw handleFirebaseException(e);
    } catch (e) {
      throw ServerException('An unexpected error occurred : $e');
    }
  }

  @override
  Future<void> sendPasswordRestEmail({required String email}) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw handleFirebaseException(e);
    } catch (e) {
      throw ServerException('An unexpected error occurred');
    }
  }

  @override
  Stream<AppUser?> get authStateChanges =>
      firebaseAuth.authStateChanges().asyncMap((user) async {
        if (user != null) {
          return await getCurrentUser();
        }
        return null;
      });

  @override
  bool isLoggedIn() {
    return firebaseAuth.currentUser != null;
  }

  @override
  Future<AppUser?> getCurrentUser() async {
    try {
      final user = firebaseAuth.currentUser;
      if (user != null) {
        final uid = user.uid;

        final doc = await firestore
            .collection(TextConstants.users)
            .doc(uid)
            .get();

        if (doc.exists && doc.data() != null) {
          return AppUserModel.fromMap(doc.data()!);
        } else {
          return AppUser(
            uid: user.uid,
            email: user.email!,
            username: user.displayName ?? "New User",
          );
        }
      }
      return null;
    } catch (e) {
      throw ServerException('Failed to retrieve current user');
    }
  }
}
