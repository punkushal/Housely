import 'package:flutter/material.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/core/constants/app_text_style.dart';
import 'package:housely/core/constants/image_constant.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';

class TopLocationCard extends StatelessWidget {
  const TopLocationCard({super.key, required this.location});

  /// location name
  final String location;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: ResponsiveDimensions.paddingOnly(
        context,
        right: 8,
        top: 4,
        bottom: 4,
        left: 4,
      ),
      height: ResponsiveDimensions.getHeight(context, 44),
      decoration: BoxDecoration(
        borderRadius: ResponsiveDimensions.borderRadiusSmall(context, size: 10),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        spacing: ResponsiveDimensions.getSize(context, 8),
        children: [
          ClipRRect(
            borderRadius: ResponsiveDimensions.borderRadiusSmall(context),
            child: Image.asset(
              ImageConstant.secondVilla,
              width: ResponsiveDimensions.getSize(context, 36),
              height: ResponsiveDimensions.getHeight(context, 36),
              fit: .cover,
            ),
          ),

          Text(
            location,
            style: AppTextStyle.labelSemiBold(
              context,
              fontSize: 12,
              lineHeight: 14,
              color: AppColors.textHint,
            ),
          ),
        ],
      ),
    );
  }
}
