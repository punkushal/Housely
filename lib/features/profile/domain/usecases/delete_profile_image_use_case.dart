import 'package:equatable/equatable.dart';
import 'package:housely/core/usecases/usecase.dart';
import 'package:housely/core/utils/typedef.dart';
import 'package:housely/features/profile/domain/repository/profile_repo.dart';

class DeleteProfileImageUseCase
    implements UseCase<void, DeleteProfileImageParam> {
  final ProfileRepo profileRepo;

  DeleteProfileImageUseCase(this.profileRepo);
  @override
  ResultVoid call(params) async {
    return await profileRepo.deleteProfileImage(fileId: params.fileId);
  }
}

class DeleteProfileImageParam extends Equatable {
  final String fileId;

  const DeleteProfileImageParam(this.fileId);
  @override
  List<Object?> get props => [fileId];
}
