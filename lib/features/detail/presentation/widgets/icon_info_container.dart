import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/core/constants/app_text_style.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';

class IconInfoContainer extends StatelessWidget {
  const IconInfoContainer({
    super.key,
    required this.label,
    required this.iconPath,
    required this.number,
    this.isArea = false,
  });

  /// label text
  final String label;

  /// svg icon path
  final String iconPath;

  /// count value
  final int number;

  /// area checker
  final bool isArea;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      spacing: ResponsiveDimensions.getHeight(context, 4),
      children: [
        Text(
          label,
          style: AppTextStyle.bodyRegular(
            context,
            lineHeight: 14,
            color: AppColors.textHint,
          ),
        ),
        Row(
          children: [
            SvgPicture.asset(
              iconPath,
              width: ResponsiveDimensions.getSize(context, 16),
              height: ResponsiveDimensions.getHeight(context, 16),
              colorFilter: ColorFilter.mode(AppColors.primaryPressed, .srcIn),
            ),
            Text(
              isArea ? "$number sqft" : number.toString(),
              style: AppTextStyle.labelSemiBold(
                context,
                fontSize: 12,
                lineHeight: 14,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
