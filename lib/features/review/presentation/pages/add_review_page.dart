import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housely/core/constants/text_constants.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';
import 'package:housely/core/utils/snack_bar_helper.dart';
import 'package:housely/core/widgets/custom_button.dart';
import 'package:housely/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:housely/features/property/domain/entities/property.dart';
import 'package:housely/features/property/presentation/widgets/upload_container.dart';
import 'package:housely/features/review/domain/entity/review.dart';
import 'package:housely/features/review/presentation/bloc/review_bloc.dart';
import 'package:housely/features/review/presentation/widgets/rating_section.dart';
import 'package:housely/features/review/presentation/widgets/write_review_container.dart';
import 'package:housely/injection_container.dart';

@RoutePage()
class AddReviewPage extends StatefulWidget implements AutoRouteWrapper {
  const AddReviewPage({super.key, required this.property, this.existedReview});
  final Property property;
  final Review? existedReview;
  @override
  State<AddReviewPage> createState() => _AddReviewPageState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = sl<ReviewBloc>();

        if (existedReview != null) {
          bloc.add(
            SetInitialValues(
              ratings: existedReview!.rating.toInt(),
              existingNetworkImages: existedReview!.reviewImages != null
                  ? List<Map<String, dynamic>>.from(
                      existedReview!.reviewImages!['images'],
                    )
                  : [],
            ),
          );
        }
        return bloc;
      },
      child: this,
    );
  }
}

class _AddReviewPageState extends State<AddReviewPage> {
  final TextEditingController _reviewController = .new();

  @override
  void initState() {
    super.initState();
    if (widget.existedReview != null) {
      _reviewController.text = widget.existedReview!.comment;
    }
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  void onReviewSubmit(BuildContext context) {
    final comment = _reviewController.text.trim();
    if (comment.isEmpty) {
      return SnackbarHelper.showError(context, "Please write your review");
    }
    if (comment.length < 10) {
      return SnackbarHelper.showError(
        context,
        "Review must be at least 10 characters",
      );
    }

    final reviewState = context.read<ReviewBloc>().state;

    final ratings = reviewState.ratings;

    if (ratings == null) {
      return SnackbarHelper.showError(context, "Please give your ratings");
    }
    final hasReview = widget.existedReview != null;
    final authState = context.read<AuthCubit>().state as Authenticated;
    final review = Review(
      reviewId: hasReview
          ? widget.existedReview!.reviewId
          : "", // in remote source it'll be added
      userId: hasReview
          ? widget.existedReview!.userId
          : authState.currentUser!.uid,
      userName: hasReview
          ? widget.existedReview!.userName
          : authState.currentUser!.username,
      rating: ratings.toDouble() + 1,
      comment: comment,
      createdAt: hasReview ? widget.existedReview!.createdAt : .now(),
      updatedAt: hasReview ? .now() : null,
      reviewImages: hasReview
          ? {'images': reviewState.existingNetworkImages}
          : null,
    );
    hasReview
        ? context.read<ReviewBloc>().add(
            UpdateReview(
              updatedReview: review,
              propertyId: widget.property.id!,
              oldRating: widget.existedReview!.rating,
            ),
          )
        : context.read<ReviewBloc>().add(
            AddReview(review: review, propertyId: widget.property.id!),
          );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReviewBloc, ReviewState>(
      listener: (context, state) {
        if (state.status == .error) {
          SnackbarHelper.showError(context, state.errorMessage!);
        } else if (state.status == .success) {
          SnackbarHelper.showSuccess(
            context,
            widget.existedReview != null
                ? 'Review updated successfully'
                : 'Review added successfully',
          );
          // Return true to indicate data has changed (for update case)
          // This will trigger parent refresh
          Future.delayed(Duration(milliseconds: 300), () {
            if (context.mounted) {
              context.pop(widget.existedReview != null ? true : null);
            }
          });
        } else if (state.imageError != null) {
          SnackbarHelper.showError(context, state.imageError!);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              widget.existedReview != null ? "Edit Review" : 'Write a review',
            ),
          ),
          body: Padding(
            padding: ResponsiveDimensions.paddingSymmetric(
              context,
              horizontal: 22,
              vertical: 12,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: .start,
                spacing: ResponsiveDimensions.spacing16(context),
                children: [
                  // upload review images
                  UploadContainer(
                    labelText: "Add Photos",
                    hasMany: true,
                    imageList: state.localImages,
                    networkImages: state.existingNetworkImages
                        .map((e) => e['url'] as String)
                        .toList(),
                    onImagesSelected: (files) {
                      final authState =
                          context.read<AuthCubit>().state as Authenticated;
                      context.read<ReviewBloc>().add(
                        AddReviewImages(
                          reviewImages: files,
                          userEmail: authState.currentUser!.email,
                        ),
                      );
                    },
                    onRemoveLocal: (index) {
                      context.read<ReviewBloc>().add(
                        RemoveReviewImage(index: index),
                      );
                    },
                    onRemoveNetwork: (index) {
                      context.read<ReviewBloc>().add(
                        RemoveNetworkReviewImage(index: index),
                      );
                    },
                  ),

                  // review section
                  WriteReviewContainer(reviewController: _reviewController),

                  // rating section
                  RatingSection(),
                  SizedBox(height: ResponsiveDimensions.spacing32(context)),
                  CustomButton(
                    onTap: () => onReviewSubmit(context),
                    buttonLabel: widget.existedReview != null
                        ? "Update Review"
                        : TextConstants.submit,
                    isLoading: state.status == .loading,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
