import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:housely/core/usecases/usecase.dart';
import 'package:housely/core/utils/typedef.dart';
import 'package:housely/features/auth/domain/repositories/auth_repo.dart';

class LoginUseCase implements UseCase<Unit, LoginParams> {
  final AuthRepo repository;

  LoginUseCase(this.repository);

  @override
  ResultFuture<Unit> call(LoginParams params) async {
    return await repository.login(
      email: params.email,
      password: params.password,
    );
  }
}

class LoginParams extends Equatable {
  final String email;
  final String password;

  const LoginParams({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}
