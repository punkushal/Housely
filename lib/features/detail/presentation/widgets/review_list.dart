import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housely/app/app_router.gr.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';
import 'package:housely/features/detail/presentation/widgets/review_card.dart';
import 'package:housely/features/property/domain/entities/property.dart';
import 'package:housely/features/review/domain/entity/review.dart';
import 'package:housely/features/review/presentation/bloc/review_bloc.dart';

class ReviewList extends StatelessWidget {
  const ReviewList({
    super.key,
    required this.allReviewsList,
    this.showAll = false,
    required this.property,
  });
  final List<Review> allReviewsList;
  final bool showAll;
  final Property property;
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
            child: GestureDetector(
              onTap: () async {
                final result = await context.router.push(
                  ReviewDetailRoute(
                    review: allReviewsList[index],
                    property: property,
                    totalReviews: allReviewsList.length,
                  ),
                );

                // If review was deleted or updated, refresh the reviews list
                if (result == true && context.mounted) {
                  // Trigger refresh by fetching all reviews
                  try {
                    context.read<ReviewBloc>().add(
                      GetAllReviews(propertyId: property.id!),
                    );
                  } catch (e) {
                    // Bloc not available in context
                  }
                }
              },
              child: ReviewCard(
                review: allReviewsList[index],
                isDetailView: showAll,
              ),
            ),
          );
        },
      ),
    );
  }
}
