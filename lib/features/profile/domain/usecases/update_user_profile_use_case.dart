import 'package:equatable/equatable.dart';
import 'package:housely/core/usecases/usecase.dart';
import 'package:housely/core/utils/typedef.dart';
import 'package:housely/features/auth/domain/entities/app_user.dart';
import 'package:housely/features/profile/domain/repository/profile_repo.dart';
import 'package:housely/features/property/domain/entities/property_owner.dart';

class UpdateUserProfileUseCase
    implements UseCase<void, UpdateUserProfileParams> {
  final ProfileRepo profileRepo;

  UpdateUserProfileUseCase(this.profileRepo);
  @override
  ResultVoid call(params) async {
    return await profileRepo.updateUserProfile(
      currentUser: params.appUser,
      currnetOwner: params.owner,
    );
  }
}

class UpdateUserProfileParams extends Equatable {
  final AppUser appUser;
  final PropertyOwner? owner;

  const UpdateUserProfileParams({required this.appUser, this.owner});
  @override
  List<Object?> get props => [appUser, owner];
}
