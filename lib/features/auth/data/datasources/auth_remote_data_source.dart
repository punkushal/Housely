import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:housely/core/error/exception.dart';
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

  AuthRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.googleSignInInstance,
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
      throw _handleFirebaseException(e);
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

      // Update display name
      await userCredential.user?.updateDisplayName(username);
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseException(e);
    } catch (e) {
      throw ServerException('An unexpected error occurred');
    }
  }

  // handle firebase exception
  AuthException _handleFirebaseException(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return AuthException('Invalid email address');
      case 'wrong-password':
        return AuthException('Wrong password');
      case 'user-not-found':
        return AuthException('User not found');
      case 'user-disabled':
        return AuthException('This account has been disabled');
      case 'email-already-in-use':
        return AuthException('An account already exists with this email');
      case 'weak-password':
        return AuthException('Password is too weak. Use at least 6 characters');
      case 'network-request-failed':
        return AuthException('No internet connection');
      default:
        return AuthException(e.message ?? 'Authentication failed');
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
      return appUser;
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseException(e);
    } catch (e) {
      throw ServerException('An unexpected error occurred');
    }
  }

  @override
  Future<void> sendPasswordRestEmail({required String email}) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseException(e);
    } catch (e) {
      throw ServerException('An unexpected error occurred');
    }
  }

  @override
  Stream<AppUser?> get authStateChanges =>
      firebaseAuth.authStateChanges().map((user) {
        if (user != null) {
          return AppUser(
            uid: user.uid,
            email: user.email!,
            username: user.displayName ?? "no user name",
          );
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
      final hasCurrentUser = firebaseAuth.currentUser != null;
      if (hasCurrentUser) {
        return AppUser(
          uid: firebaseAuth.currentUser!.uid,
          email: firebaseAuth.currentUser!.email!,
          username: firebaseAuth.currentUser!.displayName!,
        );
      }
      return null;
    } catch (e) {
      throw ServerException('Failed to retrieve current user');
    }
  }
}
