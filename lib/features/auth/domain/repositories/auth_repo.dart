import 'package:fpdart/fpdart.dart';
import 'package:housely/core/utils/typedef.dart';

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
}
