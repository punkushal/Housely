import 'package:flutter/material.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';

class DropShadow extends StatelessWidget {
  const DropShadow({super.key, this.boxShadow, this.child});

  /// list of box shadows
  final List<BoxShadow>? boxShadow;

  /// widget
  final Widget? child;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow:
            boxShadow ??
            [
              BoxShadow(
                offset: Offset(0, 20),
                blurRadius: ResponsiveDimensions.radiusXLarge(context),
                spreadRadius: ResponsiveDimensions.radiusSmall(
                  context,
                  size: -4,
                ),
                color: AppColors.primary.withValues(alpha: 0.08),
              ),
              BoxShadow(
                offset: Offset(0, 8),
                blurRadius: ResponsiveDimensions.radiusSmall(context),
                spreadRadius: ResponsiveDimensions.radiusSmall(
                  context,
                  size: -4,
                ),
                color: AppColors.primary.withValues(alpha: 0.03),
              ),
            ],
      ),
      child: child,
    );
  }
}
