import 'package:equatable/equatable.dart';
import 'package:housely/core/usecases/usecase.dart';
import 'package:housely/core/utils/typedef.dart';
import 'package:housely/features/review/domain/repository/review_repo.dart';

class DeleteReviewUseCase implements UseCase<void, DeleteReviewParams> {
  final ReviewRepo repo;

  DeleteReviewUseCase(this.repo);
  @override
  ResultFuture<void> call(params) async {
    return await repo.deleteReview(
      reviewId: params.reviewId,
      propertyId: params.propertyId,
      ratingToDelete: params.ratingToDelete,
    );
  }
}

class DeleteReviewParams extends Equatable {
  final String reviewId;
  final String propertyId;
  final double ratingToDelete;

  const DeleteReviewParams({
    required this.reviewId,
    required this.propertyId,
    required this.ratingToDelete,
  });

  @override
  List<Object?> get props => [reviewId, propertyId, ratingToDelete];
}
