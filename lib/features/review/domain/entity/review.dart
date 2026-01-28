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
  final List<Map<String, dynamic>> reviewImages;

  const Review({
    required this.reviewId,
    required this.userId,
    required this.userName,
    this.userProfile,
    required this.rating,
    required this.comment,
    required this.createdAt,
    required this.updatedAt,
    required this.reviewImages,
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
}
