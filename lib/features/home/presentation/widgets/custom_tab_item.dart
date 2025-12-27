import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:housely/core/constants/app_text_style.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';

class CustomTabItem extends StatelessWidget {
  const CustomTabItem({
    super.key,
    required this.iconPath,
    required this.label,
    this.labelColor,
  });

  /// tab icon path
  final String iconPath;

  /// tab label
  final String label;

  /// tab label text color
  final Color? labelColor;
  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: ResponsiveDimensions.getHeight(context, 4),
      mainAxisAlignment: .center,
      children: [
        SvgPicture.asset(iconPath),
        Text(
          label,
          style: AppTextStyle.labelMedium(context, color: labelColor),
        ),
      ],
    );
  }
}
