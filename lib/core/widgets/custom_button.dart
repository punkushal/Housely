import 'package:flutter/material.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';

class CustomButton extends StatelessWidget {
  /// Custom Reusable Button Widget
  const CustomButton({
    super.key,
    this.height,
    this.child,
    required this.onTap,
    required this.horizontal,
  });

  /// Button's height
  final double? height;

  /// Widget
  final Widget? child;

  /// Button's on tap function
  final void Function() onTap;

  /// Padding value for horizontal
  final double horizontal;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: ResponsiveDimensions.paddingSymmetric(
          context,
          horizontal: horizontal,
        ),
        alignment: .center,
        width: double.infinity,
        height: height == null
            ? ResponsiveDimensions.buttonHeight(context)
            : ResponsiveDimensions.buttonHeight(context, buttonHeight: height),
        decoration: BoxDecoration(
          borderRadius: ResponsiveDimensions.borderRadiusSmall(context),
          color: AppColors.primary,
        ),
        child: child,
      ),
    );
  }
}
