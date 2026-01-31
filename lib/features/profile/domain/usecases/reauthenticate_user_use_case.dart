import 'package:housely/core/usecases/usecase.dart';
import 'package:housely/core/utils/typedef.dart';
import 'package:housely/features/profile/domain/repository/profile_repo.dart';

class ReauthenticateUserUseCase implements UseCase<void, String> {
  final ProfileRepo profileRepo;

  ReauthenticateUserUseCase(this.profileRepo);
  @override
  ResultFuture<void> call(String password) async {
    return await profileRepo.reauthenticateUser(password);
  }
}
