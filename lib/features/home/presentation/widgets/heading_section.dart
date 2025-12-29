import 'package:flutter/material.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/core/constants/app_text_style.dart';

class HeadingSection extends StatelessWidget {
  const HeadingSection({
    super.key,
    required this.title,
    required this.onTapText,
    this.onTap,
  });

  /// Heading title
  final String title;

  /// Tappable text
  final String onTapText;

  /// on tap for tappable text
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: .spaceBetween,
      children: [
        Text(
          title,
          style: AppTextStyle.bodySemiBold(
            context,
            fontSize: 16,
            lineHeight: 24,
          ),
        ),

        GestureDetector(
          onTap: onTap,
          child: Text(
            onTapText,
            style: AppTextStyle.labelMedium(
              context,
              fontSize: 12,
              color: AppColors.primaryPressed,
            ),
          ),
        ),
      ],
    );
  }
}
