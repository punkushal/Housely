import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/core/constants/app_text_style.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';
import 'package:housely/core/widgets/custom_text_field.dart';

class WriteReviewContainer extends StatefulWidget {
  const WriteReviewContainer({super.key, required this.reviewController});
  final TextEditingController reviewController;
  @override
  State<WriteReviewContainer> createState() => _WriteReviewContainerState();
}

class _WriteReviewContainerState extends State<WriteReviewContainer> {
  static const int maxChars = 350;
  int remainingChars = maxChars;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      spacing: ResponsiveDimensions.spacing8(context),
      children: [
        Text(
          "Write your review",
          style: AppTextStyle.bodySemiBold(
            context,
            fontSize: 16,
            lineHeight: 24,
          ),
        ),

        DottedBorder(
          options: RoundedRectDottedBorderOptions(
            padding: .zero,
            radius: Radius.circular(ResponsiveDimensions.radiusSmall(context)),
            dashPattern: [4, 5],
            color: AppColors.border,
          ),
          child: CustomTextField(
            controller: widget.reviewController,
            border: .none,
            maxLines: 8,
            maxLength: maxChars,
            contentPadding: ResponsiveDimensions.paddingAll8(context),
            onChanged: (value) {
              setState(() {
                remainingChars = maxChars - value.length;
              });
            },
          ),
        ),

        Row(
          mainAxisAlignment: .end,
          children: [
            Text(
              "$remainingChars characters remaining",
              style: AppTextStyle.bodyRegular(
                context,
                color: remainingChars < 20
                    ? AppColors.error
                    : AppColors.textHint,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
