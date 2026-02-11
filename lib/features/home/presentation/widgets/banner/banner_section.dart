import 'package:flutter/material.dart';
import 'package:housely/core/constants/image_constant.dart';
import 'package:housely/core/extensions/context_extension.dart';

class BannerSection extends StatelessWidget {
  const BannerSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(context.sp12),
      child: Image.asset(
        ImageConstant.bannerImg,
        height: context.responsive(110),
        fit: .cover,
      ),
    );
  }
}
