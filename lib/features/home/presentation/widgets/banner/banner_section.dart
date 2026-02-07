import 'package:flutter/material.dart';
import 'package:housely/core/constants/image_constant.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';

class BannerSection extends StatelessWidget {
  const BannerSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.asset(
        ImageConstant.bannerImg,
        height: ResponsiveDimensions.getSize(context, 110),
        fit: .cover,
      ),
    );
  }
}
