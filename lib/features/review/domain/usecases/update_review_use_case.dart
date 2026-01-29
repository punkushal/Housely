import 'package:equatable/equatable.dart';
import 'package:housely/core/usecases/usecase.dart';
import 'package:housely/core/utils/typedef.dart';
import 'package:housely/features/review/domain/entity/review.dart';
import 'package:housely/features/review/domain/repository/review_repo.dart';

class UpdateReviewUseCase implements UseCase<void, UpdateReviewParams> {
  final ReviewRepo repo;

  UpdateReviewUseCase(this.repo);
  @override
  ResultVoid call(params) async {
    return await repo.updateReview(
      review: params.review,
      propertyId: params.propertyId,
      oldRating: params.oldRating,
    );
  }
}

class UpdateReviewParams extends Equatable {
  final String propertyId;
  final Review review;
  final double oldRating;

  const UpdateReviewParams({
    required this.propertyId,
    required this.review,
    required this.oldRating,
  });
  @override
  List<Object?> get props => [review, propertyId, oldRating];
}
