import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:housely/core/usecases/usecase.dart';
import 'package:housely/core/utils/typedef.dart';
import 'package:housely/features/auth/domain/repositories/auth_repo.dart';

class RegisterUsecase implements UseCase<Unit, RegisterParams> {
  final AuthRepo repository;

  RegisterUsecase(this.repository);

  @override
  ResultFuture<Unit> call(RegisterParams params) async {
    return await repository.register(
      email: params.email,
      password: params.password,
      username: params.username,
    );
  }
}

class RegisterParams extends Equatable {
  final String email;
  final String username;
  final String password;

  const RegisterParams({
    required this.email,
    required this.password,
    required this.username,
  });

  @override
  List<Object> get props => [email, username, password];
}
