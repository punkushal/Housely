import 'package:fpdart/fpdart.dart';
import 'package:housely/core/utils/typedef.dart';
import 'package:housely/features/auth/domain/entities/app_user.dart';

abstract interface class AuthRepo {
  // register user
  ResultFuture<Unit> register({
    required String username,
    required String email,
    required String password,
  });

  // sign in user
  ResultFuture<Unit> login({required String email, required String password});

  // log out user
  ResultVoid logout();

  // sign in user via google
  ResultFuture<AppUser?> googleSignIn();
}
