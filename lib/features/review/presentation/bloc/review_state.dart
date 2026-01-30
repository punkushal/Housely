part of 'review_bloc.dart';

enum ReviewStatus {
  initial,
  loading,
  submitting,
  success,
  error,
  loaded,
  deleted,
}

class ReviewState extends Equatable {
  final ReviewStatus status;
  final List<File> localImages;
  final List<Map<String, dynamic>> existingNetworkImages;
  final Review? review;
  final String? errorMessage;
  final String? imageError;
  final int? ratings;
  final List<Review> allReviews;
  final DocumentSnapshot? lastDoc;
  const ReviewState({
    this.status = .initial,
    this.localImages = const [],
    this.existingNetworkImages = const [],
    this.review,
    this.errorMessage,
    this.imageError,
    this.ratings,
    this.allReviews = const [],
    this.lastDoc,
  });

  ReviewState copyWith({
    ReviewStatus? status,
    List<File>? localImages,
    List<Map<String, dynamic>>? existingNetworkImages,
    String? errorMessage,
    String? imageError,
    Review? review,
    int? ratings,
    List<Review>? allReviews,
    DocumentSnapshot? lastDoc,
  }) {
    return ReviewState(
      review: review ?? this.review,
      status: status ?? this.status,
      localImages: localImages ?? this.localImages,
      existingNetworkImages:
          existingNetworkImages ?? this.existingNetworkImages,
      errorMessage: errorMessage, // We allow resetting this to null
      imageError: imageError,
      ratings: ratings ?? this.ratings,
      allReviews: allReviews ?? this.allReviews,
      lastDoc: lastDoc ?? this.lastDoc,
    );
  }

  @override
  List<Object?> get props => [
    review,
    status,
    localImages,
    existingNetworkImages,
    imageError,
    ratings,
    allReviews,
    lastDoc,
  ];
}
