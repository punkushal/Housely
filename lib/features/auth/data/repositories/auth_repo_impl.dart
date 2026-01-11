import 'package:fpdart/fpdart.dart';
import 'package:housely/core/error/exception.dart';
import 'package:housely/core/error/failure.dart';
import 'package:housely/core/utils/typedef.dart';
import 'package:housely/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:housely/features/auth/domain/entities/app_user.dart';
import 'package:housely/features/auth/domain/repositories/auth_repo.dart';

class AuthRepoImpl implements AuthRepo {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepoImpl({required this.remoteDataSource});
  @override
  ResultFuture<Unit> login({
    required String email,
    required String password,
  }) async {
    try {
      await remoteDataSource.login(email: email, password: password);
      return const Right(unit);
    } on AuthException catch (e) {
      return Left(_mapAuthExceptionToFailure(e));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred'));
    }
  }

  @override
  ResultVoid logout() async {
    try {
      await remoteDataSource.logout();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to logout'));
    }
  }

  @override
  ResultFuture<Unit> register({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      await remoteDataSource.register(
        username: username,
        email: email,
        password: password,
      );
      return const Right(unit);
    } on AuthException catch (e) {
      return Left(_mapAuthExceptionToFailure(e));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred'));
    }
  }

  // mapping auth exception to appropriate failure
  Failure _mapAuthExceptionToFailure(AuthException e) {
    final message = e.message.toLowerCase();

    if (message.contains('invalid email') || message.contains('email')) {
      return InvalidEmailFailure();
    } else if (message.contains('password') && message.contains('wrong')) {
      return WrongPasswordFailure();
    } else if (message.contains('user not found')) {
      return UserNotFoundFailure();
    } else if (message.contains('weak password')) {
      return WeakPasswordFailure(e.message);
    } else if (message.contains('email already in use')) {
      return EmailAlreadyInUseFailure(e.message);
    } else if (message.contains('network') || message.contains('internet')) {
      return NetworkFailure(e.message);
    } else {
      return AuthFailure(e.message);
    }
  }

  @override
  ResultFuture<AppUser?> googleSignIn() async {
    try {
      final appUser = await remoteDataSource.googleSignIn();
      return Right(appUser);
    } on AuthException catch (e) {
      return Left(_mapAuthExceptionToFailure(e));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred'));
    }
  }

  @override
  ResultVoid sendPasswordResetEmail({required String email}) async {
    try {
      await remoteDataSource.sendPasswordRestEmail(email: email);
      return const Right(null);
    } on AuthException catch (e) {
      return Left(_mapAuthExceptionToFailure(e));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred'));
    }
  }

  @override
  Stream<AppUser?> get authStateChanges => remoteDataSource.authStateChanges;

  @override
  bool isLoggedIn() {
    return remoteDataSource.isLoggedIn();
  }

  @override
  ResultFuture<AppUser?> getCurrentUser() async {
    try {
      final result = await remoteDataSource.getCurrentUser();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure('Failed to get current user'));
    }
  }
}
