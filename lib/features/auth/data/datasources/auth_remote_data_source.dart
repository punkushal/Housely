import 'package:firebase_auth/firebase_auth.dart';
import 'package:housely/core/error/exception.dart';

abstract class AuthRemoteDataSource {
  Future<void> register({
    required String username,
    required String email,
    required String password,
  });

  Future<void> login({required String email, required String password});

  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;

  AuthRemoteDataSourceImpl({required this.firebaseAuth});

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
}
