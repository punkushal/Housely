// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class Review extends Equatable {
  final String reviewId;
  final String userId;
  final String userName;
  final String? userProfile;
  final double rating;
  final String comment;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final Map<String, dynamic>? reviewImages;

  const Review({
    required this.reviewId,
    required this.userId,
    required this.userName,
    this.userProfile,
    required this.rating,
    required this.comment,
    required this.createdAt,
    required this.updatedAt,
    this.reviewImages,
  });
  @override
  List<Object?> get props => [
    reviewId,
    userId,
    userName,
    userProfile,
    rating,
    comment,
    createdAt,
    updatedAt,
    reviewImages,
  ];

  Review copyWith({
    String? reviewId,
    String? userId,
    String? userName,
    String? userProfile,
    double? rating,
    String? comment,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? reviewImages,
  }) {
    return Review(
      reviewId: reviewId ?? this.reviewId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userProfile: userProfile ?? this.userProfile,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      reviewImages: reviewImages ?? this.reviewImages,
    );
  }
}
