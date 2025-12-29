import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';

class IconWrapper extends StatelessWidget {
  const IconWrapper({
    super.key,
    required this.iconPath,
    this.onTap,
    this.fit = .scaleDown,
  });

  /// icon path
  final String iconPath;

  /// on tap function
  final void Function()? onTap;

  /// icon fit
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: ResponsiveDimensions.getSize(context, 44),
        height: ResponsiveDimensions.getHeight(context, 44),
        decoration: BoxDecoration(
          shape: .circle,
          border: Border.all(color: AppColors.textHint),
        ),
        child: SvgPicture.asset(
          iconPath,
          height: ResponsiveDimensions.getHeight(context, 24),
          width: ResponsiveDimensions.getSize(context, 24),
          fit: fit,
        ),
      ),
    );
  }
}
