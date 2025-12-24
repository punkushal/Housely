class ServerException implements Exception {
  final String message;
  ServerException([this.message = 'Server error occurred']);
}

class NetworkException implements Exception {
  final String message;
  NetworkException([this.message = 'No internet connection']);
}

class AuthException implements Exception {
  final String message;
  AuthException([this.message = 'Authentication failed']);
}

class PermissionExcetipn implements Exception {
  final String message;
  PermissionExcetipn([this.message = "Permission denied"]);
}
