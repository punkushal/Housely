part of 'review_bloc.dart';

sealed class ReviewEvent extends Equatable {
  const ReviewEvent();

  @override
  List<Object?> get props => [];
}

final class SetInitialValues extends ReviewEvent {
  final int ratings;
  final List<Map<String, dynamic>> existingNetworkImages;

  const SetInitialValues({
    required this.ratings,
    required this.existingNetworkImages,
  });

  @override
  List<Object?> get props => [ratings, existingNetworkImages];
}

final class AddReviewImages extends ReviewEvent {
  final List<File> reviewImages;
  final String userEmail;

  const AddReviewImages({required this.reviewImages, required this.userEmail});

  @override
  List<Object> get props => [userEmail, reviewImages];
}

final class RemoveReviewImage extends ReviewEvent {
  final int index;

  const RemoveReviewImage({required this.index});

  @override
  List<Object> get props => [index];
}

final class RemoveNetworkReviewImage extends ReviewEvent {
  final int index;

  const RemoveNetworkReviewImage({required this.index});

  @override
  List<Object> get props => [index];
}

final class AddRatings extends ReviewEvent {
  final int ratings;

  const AddRatings(this.ratings);

  @override
  List<Object> get props => [ratings];
}

final class RemoteRating extends ReviewEvent {
  final int index;

  const RemoteRating(this.index);
}

final class AddReview extends ReviewEvent {
  final Review review;
  final String propertyId;

  const AddReview({required this.review, required this.propertyId});

  @override
  List<Object> get props => [review, propertyId];
}

final class UpdateReview extends ReviewEvent {
  final Review updatedReview;
  final String propertyId;

  const UpdateReview({required this.updatedReview, required this.propertyId});

  @override
  List<Object> get props => [updatedReview, propertyId];
}

final class DeleteReview extends ReviewEvent {
  final Review review;
  final String propertyId;

  const DeleteReview({required this.review, required this.propertyId});

  @override
  List<Object> get props => [review, propertyId];
}

final class GetAllReviews extends ReviewEvent {
  final String propertyId;
  final DocumentSnapshot? lastDoc;

  const GetAllReviews({required this.propertyId, this.lastDoc});

  @override
  List<Object?> get props => [propertyId, lastDoc];
}
