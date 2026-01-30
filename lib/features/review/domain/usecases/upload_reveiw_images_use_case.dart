import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:housely/core/usecases/usecase.dart';
import 'package:housely/core/utils/typedef.dart';
import 'package:housely/features/review/domain/repository/review_repo.dart';

class UploadReveiwImagesUseCase
    implements UseCase<Map<String, dynamic>, UploadReviewImagesParams> {
  final ReviewRepo repo;

  UploadReveiwImagesUseCase(this.repo);
  @override
  ResultFuture<Map<String, dynamic>> call(params) async {
    return await repo.uploadReviewImages(
      images: params.images,
      userEmail: params.userEmail,
    );
  }
}

class UploadReviewImagesParams extends Equatable {
  final String userEmail;
  final List<File> images;

  const UploadReviewImagesParams({
    required this.userEmail,
    required this.images,
  });
  @override
  List<Object?> get props => [images, userEmail];
}
