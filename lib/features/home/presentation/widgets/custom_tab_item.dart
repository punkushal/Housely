import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/core/constants/app_text_style.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';

class CustomBottomNavItem extends StatelessWidget {
  const CustomBottomNavItem({
    super.key,
    required this.label,
    required this.isActive,
    required this.iconPath,
    required this.filledIconPath,
  });

  /// normal icon path
  final String iconPath;

  /// filled icon path
  final String filledIconPath;

  /// label text
  final String label;

  /// active tab checker
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          height: ResponsiveDimensions.getHeight(context, 4),
          width: isActive ? ResponsiveDimensions.getSize(context, 28) : 0,
          margin: ResponsiveDimensions.paddingOnly(context, bottom: 6),
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : Colors.transparent,
            borderRadius: ResponsiveDimensions.borderRadiusSmall(context),
          ),
        ),

        SizedBox(height: ResponsiveDimensions.getHeight(context, 11)),

        SvgPicture.asset(
          isActive ? filledIconPath : iconPath,
          width: ResponsiveDimensions.getSize(context, 24),
          height: ResponsiveDimensions.getHeight(context, 24),
          colorFilter: isActive
              ? ColorFilter.mode(AppColors.primaryPressed, .srcIn)
              : ColorFilter.mode(AppColors.textHint, .srcIn),
        ),

        SizedBox(height: ResponsiveDimensions.getHeight(context, 4)),

        Text(
          label,
          style: AppTextStyle.labelMedium(
            context,
            color: isActive ? AppColors.primary : AppColors.textHint,
          ),
        ),
      ],
    );
  }
}
