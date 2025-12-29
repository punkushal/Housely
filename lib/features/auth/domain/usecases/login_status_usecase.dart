import 'package:housely/features/auth/domain/repositories/auth_repo.dart';

class LoginStatusUsecase {
  final AuthRepo repository;

  LoginStatusUsecase(this.repository);

  bool call() {
    return repository.isLoggedIn();
  }
}
