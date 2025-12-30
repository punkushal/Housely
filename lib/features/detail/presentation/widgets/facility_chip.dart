import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/core/constants/app_text_style.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';

class FacilityChip extends StatelessWidget {
  const FacilityChip({super.key, required this.iconPath, required this.label});

  /// svg icon path
  final String iconPath;

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
      child: Row(
        spacing: ResponsiveDimensions.spacing4(context),
        crossAxisAlignment: .start,
        children: [
          SvgPicture.asset(
            iconPath,
            height: ResponsiveDimensions.getHeight(context, 18),
            width: ResponsiveDimensions.getSize(context, 18),
            colorFilter: ColorFilter.mode(AppColors.primaryPressed, .srcIn),
          ),
          Text(label, style: AppTextStyle.bodyMedium(context, fontSize: 12)),
        ],
      ),
    );
  }
}
