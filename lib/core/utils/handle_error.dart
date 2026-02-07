import 'package:appwrite/appwrite.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:housely/core/error/exception.dart';
import 'package:housely/core/error/failure.dart';

/// handle firebase related error
Failure handleFirebaseError(FirebaseException e) {
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

/// handle appwrite related errors
Failure handleAppWriteError(AppwriteException e) {
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

/// handle firebase auth exception
AuthException handleFirebaseException(FirebaseAuthException e) {
  switch (e.code) {
    case 'requires-recent-login':
      return AuthException(
        "The user must re-authenticate before this operation can be completed.",
      );
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
