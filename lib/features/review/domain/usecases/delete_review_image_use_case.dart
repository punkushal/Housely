import 'package:equatable/equatable.dart';
import 'package:housely/core/usecases/usecase.dart';
import 'package:housely/core/utils/typedef.dart';
import 'package:housely/features/review/domain/repository/review_repo.dart';

class DeleteReviewImageUseCase
    implements UseCase<void, DeleteReviewImageParam> {
  final ReviewRepo repo;

  DeleteReviewImageUseCase(this.repo);
  @override
  ResultFuture<void> call(params) async {
    return await repo.deleteImageFile(fileId: params.fileId);
  }
}

class DeleteReviewImageParam extends Equatable {
  final String fileId;

  const DeleteReviewImageParam({required this.fileId});

  @override
  List<Object?> get props => [fileId];
}
