import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housely/core/constants/text_constants.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';
import 'package:housely/core/utils/snack_bar_helper.dart';
import 'package:housely/core/widgets/custom_button.dart';
import 'package:housely/features/property/presentation/cubit/property_form_cubit.dart';
import 'package:housely/features/property/presentation/widgets/upload_container.dart';
import 'package:housely/features/review/presentation/widgets/write_review_container.dart';

@RoutePage()
class AddReviewPage extends StatefulWidget {
  const AddReviewPage({super.key});

  @override
  State<AddReviewPage> createState() => _AddReviewPageState();
}

class _AddReviewPageState extends State<AddReviewPage> {
  final TextEditingController _reviewController = .new();

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  void onReviewSubmit() {
    final review = _reviewController.text.trim();
    if (review.isEmpty) {
      return SnackbarHelper.showError(context, "Please write your review");
    } else if (review.length < 10) {
      return SnackbarHelper.showError(
        context,
        "Review must be at least 10 characters",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PropertyFormCubit(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(title: Text('Write a review')),
            body: Padding(
              padding: ResponsiveDimensions.paddingSymmetric(
                context,
                horizontal: 22,
              ),
              child: SingleChildScrollView(
                child: Column(
                  spacing: ResponsiveDimensions.spacing16(context),
                  children: [
                    UploadContainer(
                      labelText: "Add Photos",
                      hasMany: true,
                      imageList: [],
                      networkImages: [],
                    ),
                    WriteReviewContainer(reviewController: _reviewController),
                    SizedBox(height: ResponsiveDimensions.spacing32(context)),
                    CustomButton(
                      onTap: onReviewSubmit,
                      buttonLabel: TextConstants.submit,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
