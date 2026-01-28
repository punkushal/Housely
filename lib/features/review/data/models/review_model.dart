import 'package:housely/features/review/domain/entity/review.dart';

class ReviewModel extends Review {
  const ReviewModel({
    required super.reviewId,
    required super.userId,
    required super.userName,
    required super.rating,
    required super.comment,
    required super.createdAt,
    required super.updatedAt,
    required super.reviewImages,
    super.userProfile,
  });

  // from firestore
  factory ReviewModel.fromFireStore(Map<String, dynamic> json) {
    return ReviewModel(
      reviewId: json['reviewId'],
      userId: json['userId'],
      userName: json['userName'],
      rating: (json['rating'] as num).toDouble(),
      comment: json['comment'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.tryParse(json['updatedAt']),
      reviewImages: json['reviewImages'],
    );
  }

  // to firestore
  Map<String, dynamic> toFireStore() {
    return {
      'reviewId': reviewId,
      'userId': userId,
      'userName': userName,
      'rating': rating,
      'comment': comment,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt ?? updatedAt?.toIso8601String(),
      'reviewImages': reviewImages,
    };
  }

  // from entity to model class
  factory ReviewModel.fromEntity(Review review) {
    return ReviewModel(
      reviewId: review.reviewId,
      userId: review.userId,
      userName: review.userName,
      rating: review.rating,
      comment: review.comment,
      createdAt: review.createdAt,
      updatedAt: review.updatedAt,
      reviewImages: review.reviewImages,
    );
  }

  ReviewModel copyWith({
    String? reviewId,
    String? userId,
    String? userName,
    String? userProfile,
    double? rating,
    String? comment,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<Map<String, dynamic>>? reviewImages,
  }) {
    return ReviewModel(
      reviewId: reviewId ?? this.reviewId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      reviewImages: reviewImages ?? this.reviewImages,
    );
  }
}
