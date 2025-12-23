import 'package:equatable/equatable.dart';
import 'package:housely/core/usecases/usecase.dart';
import 'package:housely/core/utils/typedef.dart';
import 'package:housely/features/auth/domain/repositories/auth_repo.dart';

class SendPasswordResetUsecase implements UseCase<void, PasswordResetParams> {
  final AuthRepo repository;

  SendPasswordResetUsecase(this.repository);

  @override
  ResultVoid call(PasswordResetParams params) async {
    return await repository.sendPasswordResetEmail(email: params.email);
  }
}

class PasswordResetParams extends Equatable {
  final String email;

  const PasswordResetParams({required this.email});

  @override
  List<Object> get props => [email];
}
