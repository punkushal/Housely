import 'package:flutter/material.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/core/constants/app_text_style.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';

class FacilityChip extends StatelessWidget {
  const FacilityChip({super.key, required this.label});

  /// label
  final String label;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: ResponsiveDimensions.getHeight(context, 30),
      padding: ResponsiveDimensions.paddingSymmetric(
        context,
        vertical: 6,
        horizontal: 8,
      ),
      margin: ResponsiveDimensions.paddingOnly(context, right: 8),
      decoration: BoxDecoration(
        borderRadius: ResponsiveDimensions.borderRadiusSmall(context),
        color: AppColors.chipInActive,
      ),
      child: Text(label, style: AppTextStyle.bodyMedium(context, fontSize: 12)),
    );
  }
}
