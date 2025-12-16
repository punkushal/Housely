import 'package:flutter/material.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';

class SkipButton extends StatelessWidget {
  /// Skip button to skip onboarding content
  const SkipButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // later i'll implement skip logic
      },
      child: Container(
        alignment: .center,
        margin: ResponsiveDimensions.paddingSymmetric(
          context,
          horizontal: 16,
          vertical: 8,
        ),
        height: ResponsiveDimensions.buttonHeight(context, buttonHeight: 32),
        width: ResponsiveDimensions.buttonHeight(context, buttonHeight: 57),
        decoration: BoxDecoration(
          borderRadius: ResponsiveDimensions.borderRadiusXLarge(context),
          border: Border.all(color: AppColors.divider),
        ),
        child: Text('Skip'),
      ),
    );
  }
}
