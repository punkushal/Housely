import 'package:appwrite/appwrite.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
