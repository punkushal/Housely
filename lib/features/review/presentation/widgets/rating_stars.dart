import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/core/constants/image_constant.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';

class RatingStars extends StatelessWidget {
  const RatingStars({super.key, required this.ratings});
  final double ratings;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(5, (index) {
        return SvgPicture.asset(
          ImageConstant.starIcon,
          height: ResponsiveDimensions.spacing20(context),
          width: ResponsiveDimensions.spacing20(context),
          colorFilter: ColorFilter.mode(
            index <= (ratings - 1) ? AppColors.ratingStrong : AppColors.border,
            .srcIn,
          ),
        );
      }),
    );
  }
}
