import 'package:housely/core/usecases/usecase.dart';
import 'package:housely/core/utils/typedef.dart';
import 'package:housely/features/auth/domain/entities/app_user.dart';
import 'package:housely/features/auth/domain/repositories/auth_repo.dart';

class GoogleSigninUsecase implements UseCaseWithoutParams<AppUser?> {
  final AuthRepo repository;

  GoogleSigninUsecase(this.repository);

  @override
  ResultFuture<AppUser?> call() async {
    return await repository.googleSignIn();
  }
}
