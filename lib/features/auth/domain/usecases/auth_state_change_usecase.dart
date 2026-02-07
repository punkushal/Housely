import 'package:housely/core/usecases/usecase.dart';
import 'package:housely/core/utils/typedef.dart';
import 'package:housely/features/auth/domain/entities/app_user.dart';
import 'package:housely/features/auth/domain/repositories/auth_repo.dart';

class AuthStateChangeUsecase implements UseCaseWithStream<AppUser?> {
  final AuthRepo repository;

  AuthStateChangeUsecase(this.repository);

  @override
  ResultStream<AppUser?> call() {
    return repository.authStateChanges;
  }
}
