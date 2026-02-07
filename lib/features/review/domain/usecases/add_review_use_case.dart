import 'package:equatable/equatable.dart';
import 'package:housely/core/usecases/usecase.dart';
import 'package:housely/core/utils/typedef.dart';
import 'package:housely/features/review/domain/entity/review.dart';
import 'package:housely/features/review/domain/repository/review_repo.dart';

class AddReviewUseCase implements UseCase<void, AddReviewParams> {
  final ReviewRepo repo;

  AddReviewUseCase(this.repo);
  @override
  ResultVoid call(params) async {
    return await repo.addReview(
      review: params.review,
      propertyId: params.propertyId,
    );
  }
}

class AddReviewParams extends Equatable {
  final String propertyId;
  final Review review;

  const AddReviewParams({required this.propertyId, required this.review});
  @override
  List<Object?> get props => [review, propertyId];
}
