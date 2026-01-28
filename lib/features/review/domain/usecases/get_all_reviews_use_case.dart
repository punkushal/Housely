import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:housely/core/usecases/usecase.dart';
import 'package:housely/core/utils/typedef.dart';
import 'package:housely/features/review/domain/entity/review.dart';
import 'package:housely/features/review/domain/repository/review_repo.dart';

class GetAllReviewsUseCase
    implements
        UseCase<
          ({List<Review> reviews, DocumentSnapshot? lastDoc}),
          GetAllReviewsParams
        > {
  final ReviewRepo repo;

  GetAllReviewsUseCase(this.repo);
  @override
  ResultFuture<({List<Review> reviews, DocumentSnapshot? lastDoc})> call(
    params,
  ) async {
    return await repo.getAllReviews(
      propertyId: params.propertyId,
      lastDoc: params.lastDoc,
    );
  }
}

class GetAllReviewsParams extends Equatable {
  final String propertyId;
  final DocumentSnapshot? lastDoc;

  const GetAllReviewsParams({required this.propertyId, this.lastDoc});
  @override
  List<Object?> get props => [propertyId, lastDoc];
}
