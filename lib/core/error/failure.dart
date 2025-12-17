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
