import 'package:flutter/material.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/core/constants/app_text_style.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';

class RedirectSection extends StatelessWidget {
  const RedirectSection({
    super.key,
    required this.infoText,
    required this.redirectLinkText,
  });

  /// info text
  final String infoText;

  /// redirect link
  /// must be wrapped with gesture detector for navigation functionality
  final String redirectLinkText;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: .center,
      spacing: ResponsiveDimensions.getSize(context, 4),
      children: [
        Text(infoText, style: AppTextStyle.bodyRegular(context, fontSize: 14)),
        Text(
          redirectLinkText,
          style: AppTextStyle.bodyMedium(context, color: AppColors.primary),
        ),
      ],
    );
  }
}
