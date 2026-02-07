import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:housely/app/app_router.gr.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/core/constants/app_text_style.dart';
import 'package:housely/core/constants/image_constant.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';
import 'package:housely/core/utils/snack_bar_helper.dart';
import 'package:housely/core/widgets/custom_button.dart';
import 'package:housely/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:housely/features/detail/presentation/widgets/custom_cache_container.dart';
import 'package:housely/features/property/domain/entities/property.dart';
import 'package:housely/features/review/domain/entity/review.dart';
import 'package:housely/features/review/presentation/bloc/review_bloc.dart';
import 'package:housely/features/review/presentation/widgets/rating_stars.dart';
import 'package:housely/features/review/presentation/widgets/reviewer_photos.dart';
import 'package:housely/injection_container.dart';

@RoutePage()
class ReviewDetailPage extends StatelessWidget {
  const ReviewDetailPage({
    super.key,
    required this.review,
    required this.property,
    required this.totalReviews,
  });
  final Review review;
  final Property property;
  final int totalReviews;

  Future<void> _confirmReviewDeletion(BuildContext context) async {
    final confirmed = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Delete this review?",
          style: AppTextStyle.bodySemiBold(context, fontSize: 18),
        ),
        content: Text(
          "Are you sure you want to delete this review? This action cannot be undone.",
          style: AppTextStyle.bodyMedium(context, color: AppColors.textHint),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        actions: [
          Row(
            mainAxisAlignment: .center,
            children: [
              TextButton(
                onPressed: () {
                  context.pop(false);
                },
                child: Text(
                  'Cancel',
                  style: AppTextStyle.bodySemiBold(context),
                ),
              ),
              TextButton(
                onPressed: () {
                  context.pop(true);
                },
                child: Text(
                  'Delete',
                  style: AppTextStyle.bodySemiBold(
                    context,
                    color: AppColors.error,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      context.read<ReviewBloc>().add(
        DeleteReview(
          review: review,
          propertyId: property.id!,
          ratingToDelete: review.rating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ReviewBloc>(),
      child: BlocConsumer<ReviewBloc, ReviewState>(
        listener: (context, state) {
          if (state.status == .deleted) {
            SnackbarHelper.showSuccess(
              context,
              "This review is successfully deleted",
            );
            // Return true to indicate data has changed

            context.pop(true);
          } else if (state.status == .error) {
            SnackbarHelper.showError(context, state.errorMessage!);
          }
        },
        builder: (context, state) {
          return PopScope(
            canPop: !(state.status == .loading),
            child: Scaffold(
              appBar: AppBar(
                actions: [
                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      if (state is Authenticated &&
                          state.currentUser!.uid == review.userId) {
                        return IconButton(
                          onPressed: () async {
                            final result = await context.router.push(
                              AddReviewRoute(
                                property: property,
                                existedReview: review,
                              ),
                            );

                            // If review was updated, propagate the change back to caller
                            if (result == true && context.mounted) {
                              context.pop(true);
                            }
                          },
                          icon: Container(
                            padding: ResponsiveDimensions.paddingAll8(context),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.7),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.edit_rounded,
                              color: AppColors.background,
                              size: ResponsiveDimensions.spacing16(context),
                            ),
                          ),
                        );
                      }

                      return SizedBox.shrink();
                    },
                  ),
                  SizedBox(width: ResponsiveDimensions.spacing8(context)),
                ],
              ),
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: ResponsiveDimensions.paddingSymmetric(
                      context,
                      horizontal: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: .start,
                      spacing: ResponsiveDimensions.spacing12(context),
                      children: [
                        // property cover image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: CustomCacheContainer(
                            imageUrl: property.media.coverImage['url'],
                            width: .infinity,
                            height: ResponsiveDimensions.getSize(context, 180),
                          ),
                        ),
                        Text(
                          property.name,
                          style: AppTextStyle.headingSemiBold(
                            context,
                            fontSize: 20,
                            lineHeight: 28,
                          ),
                        ),
                        Row(
                          spacing: ResponsiveDimensions.spacing4(context),
                          children: [
                            RatingStars(ratings: property.rating.averageRating),
                            Text(
                              '${property.rating.averageRating}',
                              style: AppTextStyle.bodySemiBold(
                                context,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              "($totalReviews reviews)",
                              style: AppTextStyle.bodyMedium(
                                context,
                                color: AppColors.textHint,
                              ),
                            ),
                          ],
                        ),
                        // reviewer section
                        Row(
                          spacing: ResponsiveDimensions.spacing8(context),
                          children: [
                            CircleAvatar(
                              radius: 26,
                              backgroundColor: AppColors.divider,
                              child: SvgPicture.asset(ImageConstant.personIcon),
                            ),
                            Text(
                              review.userName,
                              style: AppTextStyle.bodySemiBold(context),
                            ),
                          ],
                        ),

                        // review comment
                        Text(review.comment),
                        SizedBox(
                          height: ResponsiveDimensions.spacing8(context),
                        ),
                        if (review.reviewImages != null &&
                            review.reviewImages!['images'].isNotEmpty)
                          Column(
                            spacing: ResponsiveDimensions.spacing4(context),
                            crossAxisAlignment: .start,
                            children: [
                              Text(
                                "User photos",
                                style: AppTextStyle.bodySemiBold(context),
                              ),
                              ReviewerPhotos(
                                imageUrls: review.reviewImages!['images'],
                              ),
                            ],
                          ),

                        SizedBox(
                          height: ResponsiveDimensions.spacing32(context),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              bottomSheet: BlocBuilder<AuthCubit, AuthState>(
                builder: (context, authState) {
                  return BlocBuilder<ReviewBloc, ReviewState>(
                    builder: (context, state) {
                      final isReviewer =
                          (authState as Authenticated).currentUser!.uid ==
                          review.userId;
                      return isReviewer
                          ? Padding(
                              padding: ResponsiveDimensions.paddingSymmetric(
                                context,
                                horizontal: 22,
                                vertical: 10,
                              ),
                              child: CustomButton(
                                onTap: () => _confirmReviewDeletion(context),
                                buttonLabel: "Delete Review",
                                isOutlined: true,
                                textColor: AppColors.error,
                                isLoading: state.status == .loading,
                              ),
                            )
                          : SizedBox.shrink();
                    },
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
