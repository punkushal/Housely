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

class PermissionException implements Exception {
  final String message;
  PermissionException([this.message = "Permission denied"]);
}
