import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:housely/core/usecases/usecase.dart';
import 'package:housely/core/utils/typedef.dart';
import 'package:housely/features/property/domain/repository/property_repo.dart';

class UploadCoverImage
    implements UseCase<Map<String, String>, UploadImageParam> {
  final PropertyRepo repository;

  UploadCoverImage(this.repository);

  @override
  ResultFuture<Map<String, String>> call(UploadImageParam params) async {
    return await repository.uploadCoverImage(
      image: params.image,
      folderType: params.folderType,
    );
  }
}

class UploadImageParam extends Equatable {
  final File image;
  final String folderType; // 'profile', 'cover', or 'gallery'
  const UploadImageParam({required this.image, required this.folderType});

  @override
  List<Object> get props => [image, folderType];
}
