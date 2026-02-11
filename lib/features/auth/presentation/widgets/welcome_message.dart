import 'package:flutter/material.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/core/constants/app_text_style.dart';
import 'package:housely/core/extensions/context_extension.dart';

class WelcomeMessage extends StatelessWidget {
  const WelcomeMessage({
    super.key,
    required this.headingTitle,
    required this.subtitle,
    this.right,
  });

  /// heading title
  final String headingTitle;

  /// subtitle info
  final String subtitle;

  /// right padding
  final double? right;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: right ?? context.responsive(70)),
      child: Column(
        spacing: context.sp8,
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
