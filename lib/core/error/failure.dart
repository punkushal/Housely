import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

// Simple local storage failure
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

class StorageInitializationFailure extends CacheFailure {
  const StorageInitializationFailure()
    : super('Failed to initialize SharedPreferences');
}

class StorageReadFailure extends CacheFailure {
  const StorageReadFailure() : super('Failed to read from local storage');
}

class StorageWriteFailure extends CacheFailure {
  const StorageWriteFailure() : super('Failed to write to local storage');
}

final class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

final class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

final class InvalidEmailFailure extends Failure {
  const InvalidEmailFailure() : super('Invalid email address');
}

final class EmailAlreadyInUseFailure extends Failure {
  const EmailAlreadyInUseFailure(super.message);
}

final class WrongPasswordFailure extends Failure {
  const WrongPasswordFailure() : super('Wrong password');
}

final class WeakPasswordFailure extends Failure {
  const WeakPasswordFailure(super.message);
}

final class UserNotFoundFailure extends Failure {
  const UserNotFoundFailure() : super("User not found");
}

final class UnknownFailure extends Failure {
  const UnknownFailure(super.message);
}

final class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

final class PermissionFailure extends Failure {
  const PermissionFailure(super.message);
}

// app write related failure
final class StorageUploadFailure extends Failure {
  const StorageUploadFailure(super.message);
}

final class StorageDeleteFailure extends Failure {
  const StorageDeleteFailure(super.message);
}

final class InvalidFileFailure extends Failure {
  const InvalidFileFailure(super.message);
}

final class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure(super.message);
}

// failure related to firebase firestore
final class ResourceExceedFailure extends Failure {
  const ResourceExceedFailure(super.message);
}

final class DeadlineExceedFailure extends Failure {
  const DeadlineExceedFailure(super.message);
}
