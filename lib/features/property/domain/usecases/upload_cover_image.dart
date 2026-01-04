import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:housely/core/usecases/usecase.dart';
import 'package:housely/core/utils/typedef.dart';
import 'package:housely/features/property/domain/repository/property_repo.dart';

class UploadCoverImage implements UseCase<String, UploadImageParam> {
  final PropertyRepo repository;

  UploadCoverImage(this.repository);

  @override
  ResultFuture<String> call(UploadImageParam params) async {
    return await repository.uploadCoverImage(params.image);
  }
}

class UploadImageParam extends Equatable {
  final File image;

  const UploadImageParam({required this.image});

  @override
  List<Object> get props => [image];
}
