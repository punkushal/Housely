import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:housely/core/usecases/usecase.dart';
import 'package:housely/core/utils/typedef.dart';
import 'package:housely/features/property/domain/repository/property_repo.dart';

class UploadPropertyImages
    implements UseCase<Map<String, String>, UploadImagesParam> {
  final PropertyRepo repository;

  UploadPropertyImages(this.repository);

  @override
  ResultFuture<Map<String, String>> call(UploadImagesParam params) async {
    return await repository.uploadPropertyImages(
      images: params.images,
      ownerEmail: params.ownerEmail,
    );
  }
}

class UploadImagesParam extends Equatable {
  final List<File> images;
  final String ownerEmail;

  const UploadImagesParam({required this.images, required this.ownerEmail});

  @override
  List<Object> get props => [images, ownerEmail];
}
