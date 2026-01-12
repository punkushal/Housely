import 'package:housely/core/usecases/usecase.dart';
import 'package:housely/core/utils/typedef.dart';
import 'package:housely/features/auth/domain/entities/app_user.dart';
import 'package:housely/features/auth/domain/repositories/auth_repo.dart';

class GetCurrentUserUseCase implements UseCaseWithoutParams {
  final AuthRepo authRepo;

  GetCurrentUserUseCase(this.authRepo);
  @override
  ResultFuture<AppUser?> call() async {
    return await authRepo.getCurrentUser();
  }
}
