import 'package:flutter/material.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';
import 'package:housely/features/detail/presentation/widgets/review_card.dart';
import 'package:housely/features/review/domain/entity/review.dart';

class ReviewList extends StatelessWidget {
  const ReviewList({
    super.key,
    required this.allReviewsList,
    this.showAll = false,
  });
  final List<Review> allReviewsList;
  final bool showAll;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: showAll
          ? .infinity
          : ResponsiveDimensions.getHeight(context, 104),
      child: ListView.builder(
        scrollDirection: showAll ? .vertical : .horizontal,
        itemCount: showAll
            ? allReviewsList.length
            : allReviewsList.take(3).length,
        itemBuilder: (context, index) {
          return Padding(
            padding: ResponsiveDimensions.paddingOnly(
              context,
              right: showAll ? 20 : 12,
              bottom: showAll ? 12 : 0,
              left: showAll ? 20 : 0,
            ),
            child: ReviewCard(
              review: allReviewsList[index],
              isDetailView: showAll,
            ),
          );
        },
      ),
    );
  }
}
