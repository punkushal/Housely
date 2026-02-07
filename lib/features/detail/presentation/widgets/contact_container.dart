import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';

class ContactContainer extends StatelessWidget {
  const ContactContainer({super.key, required this.iconPath, this.onTap});

  ///svg icon path
  final String iconPath;

  /// navigate to selected feature
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(ResponsiveDimensions.getSize(context, 6)),
        width: ResponsiveDimensions.getSize(context, 36),
        height: ResponsiveDimensions.getHeight(context, 36),
        decoration: BoxDecoration(
          shape: .circle,
          color: AppColors.chipInActive,
        ),
        child: SvgPicture.asset(
          iconPath,
          width: ResponsiveDimensions.getSize(context, 24),
          height: ResponsiveDimensions.getHeight(context, 24),
          colorFilter: ColorFilter.mode(AppColors.primaryPressed, .srcIn),
        ),
      ),
    );
  }
}
