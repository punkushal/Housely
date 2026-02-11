import 'package:flutter/material.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/core/extensions/context_extension.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';

class SkipButton extends StatelessWidget {
  /// Skip button to skip onboarding content
  const SkipButton({super.key, this.onTap});

  /// on tap function
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: .center,
        margin: ResponsiveDimensions.paddingSymmetric(
          context,
          horizontal: 16,
          vertical: 8,
        ),
        height: context.sp32,
        width: context.responsive(57),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(context.sp24),
          border: Border.all(color: AppColors.divider),
        ),
        child: Text('Skip'),
      ),
    );
  }
}
