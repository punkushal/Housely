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
    this.notificationCount = 0,
  });

  /// icon path
  final String iconPath;

  /// on tap function
  final void Function()? onTap;

  /// icon fit
  final BoxFit fit;

  /// notification count
  final int notificationCount;

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
        child: Stack(
          alignment: Alignment.center,
          children: [
            SvgPicture.asset(
              iconPath,
              height: ResponsiveDimensions.getHeight(context, 24),
              width: ResponsiveDimensions.getSize(context, 24),
              fit: fit,
            ),
            if (notificationCount > 0)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Center(
                    child: Text(
                      notificationCount > 3
                          ? '3+'
                          : notificationCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
