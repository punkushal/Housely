import 'package:flutter/material.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/core/constants/image_constant.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';

class GoogleSignInContainer extends StatelessWidget {
  const GoogleSignInContainer({super.key, this.onTap});

  /// on tap function
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: ResponsiveDimensions.getSize(context, 46),
        height: ResponsiveDimensions.getHeight(context, 46),
        decoration: BoxDecoration(
          color: AppColors.divider,
          shape: .circle,
          image: DecorationImage(image: AssetImage(ImageConstant.googleIcon)),
        ),
      ),
    );
  }
}
