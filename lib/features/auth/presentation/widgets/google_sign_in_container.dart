import 'package:flutter/material.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/core/constants/image_constant.dart';
import 'package:housely/core/extensions/context_extension.dart';

class GoogleSignInContainer extends StatelessWidget {
  const GoogleSignInContainer({super.key, this.onTap});

  /// on tap function
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: context.responsive(46),
        height: context.responsive(46),
        decoration: BoxDecoration(
          color: AppColors.divider,
          shape: .circle,
          image: DecorationImage(image: AssetImage(ImageConstant.googleIcon)),
        ),
      ),
    );
  }
}
