import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/core/constants/app_text_style.dart';
import 'package:housely/core/constants/image_constant.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';

class DefaultUploadContent extends StatelessWidget {
  const DefaultUploadContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: .center,
        children: [
          SvgPicture.asset(
            ImageConstant.uploadIcon,
            width: ResponsiveDimensions.getSize(context, 60),
            height: ResponsiveDimensions.getSize(context, 60),
            fit: .scaleDown,
            colorFilter: ColorFilter.mode(AppColors.primaryPressed, .srcIn),
          ),

          Text(
            "Click here to upload",
            style: AppTextStyle.bodyRegular(context, color: AppColors.textHint),
          ),
        ],
      ),
    );
  }
}
