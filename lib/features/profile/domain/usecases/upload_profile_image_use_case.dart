import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:housely/core/usecases/usecase.dart';
import 'package:housely/core/utils/typedef.dart';
import 'package:housely/features/profile/domain/repository/profile_repo.dart';

class UploadProfileImageUseCase
    implements UseCase<Map<String, dynamic>, UploadProfileParams> {
  final ProfileRepo profileRepo;

  UploadProfileImageUseCase(this.profileRepo);
  @override
  ResultFuture<Map<String, String>> call(params) async {
    return await profileRepo.uploadProfileImage(
      image: params.image,
      folderType: params.folderType,
      email: params.email,
    );
  }
}

class UploadProfileParams extends Equatable {
  final File image;
  final String folderType;
  final String email;

  const UploadProfileParams({
    required this.image,
    required this.folderType,
    required this.email,
  });
  @override
  List<Object?> get props => throw UnimplementedError();
}
