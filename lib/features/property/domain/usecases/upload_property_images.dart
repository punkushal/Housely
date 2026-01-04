import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:housely/core/usecases/usecase.dart';
import 'package:housely/core/utils/typedef.dart';
import 'package:housely/features/property/domain/repository/property_repo.dart';

class UploadPropertyImages implements UseCase<List<String>, UploadImagesParam> {
  final PropertyRepo repository;

  UploadPropertyImages(this.repository);

  @override
  ResultFuture<List<String>> call(UploadImagesParam params) async {
    return await repository.uploadPropertyImages(params.images);
  }
}

class UploadImagesParam extends Equatable {
  final List<File> images;

  const UploadImagesParam({required this.images});

  @override
  List<Object> get props => [images];
}
