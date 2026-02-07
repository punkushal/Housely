import 'package:housely/core/usecases/usecase.dart';
import 'package:housely/core/utils/typedef.dart';
import 'package:housely/features/auth/domain/repositories/auth_repo.dart';

class LogOutUseCase implements UseCaseWithoutParams<void> {
  final AuthRepo repository;

  LogOutUseCase(this.repository);

  @override
  ResultVoid call() async {
    return await repository.logout();
  }
}
