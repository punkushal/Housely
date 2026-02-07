import 'package:flutter/material.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/core/constants/app_text_style.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';

class RedirectSection extends StatelessWidget {
  /// Redirect section for appropriate auth page
  const RedirectSection({
    super.key,
    required this.infoText,
    required this.redirectLinkText,
    required this.navigateTo,
  });

  /// info text
  final String infoText;

  /// redirect link label text
  final String redirectLinkText;

  /// on tap navigation
  final void Function() navigateTo;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: .center,
      spacing: ResponsiveDimensions.getSize(context, 4),
      children: [
        Text(infoText, style: AppTextStyle.bodyRegular(context, fontSize: 14)),
        GestureDetector(
          onTap: navigateTo,
          child: Text(
            redirectLinkText,
            style: AppTextStyle.bodyMedium(context, color: AppColors.primary),
          ),
        ),
      ],
    );
  }
}
