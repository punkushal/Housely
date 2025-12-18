import 'package:flutter/material.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/core/constants/app_text_style.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';

class WelcomeMessage extends StatelessWidget {
  const WelcomeMessage({
    super.key,
    required this.headingTitle,
    required this.subtitle,
  });

  /// heading title
  final String headingTitle;

  /// subtitle info
  final String subtitle;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ResponsiveDimensions.paddingOnly(context, left: 24, right: 88),
      child: Column(
        spacing: ResponsiveDimensions.getHeight(context, 8),
        crossAxisAlignment: .start,
        children: [
          // heading title section
          Text(
            headingTitle,
            style: AppTextStyle.headingSemiBold(
              context,
              fontSize: 20,
              lineHeight: 26,
            ),
          ),

          // subtitle section
          Text(
            subtitle,
            style: AppTextStyle.bodyRegular(
              context,
              fontSize: 14,
              color: AppColors.textHint,
            ),
          ),
        ],
      ),
    );
  }
}
