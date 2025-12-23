import 'package:flutter/material.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/core/constants/app_text_style.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';

enum SnackbarType { success, error, info, warning }

class SnackbarHelper {
  static void showSuccess(BuildContext context, String message) {
    _showSnackbar(context, message, SnackbarType.success);
  }

  static void showError(BuildContext context, String message) {
    _showSnackbar(context, message, SnackbarType.error);
  }

  static void showInfo(BuildContext context, String message) {
    _showSnackbar(context, message, SnackbarType.info);
  }

  static void showWarning(BuildContext context, String message) {
    _showSnackbar(context, message, SnackbarType.warning);
  }

  static void _showSnackbar(
    BuildContext context,
    String message,
    SnackbarType type,
  ) {
    final config = _getSnackbarConfig(type);

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              config.icon,
              color: AppColors.surface,
              size: ResponsiveDimensions.getSize(context, 24),
            ),
            ResponsiveDimensions.gapW12(context),
            Expanded(
              child: Text(
                message,
                style: AppTextStyle.bodyMedium(
                  context,
                  fontSize: 15,
                  color: AppColors.surface,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: config.backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: ResponsiveDimensions.borderRadiusMedium(context),
        ),
        margin: ResponsiveDimensions.paddingAll16(context),
        padding: ResponsiveDimensions.paddingSymmetric(
          context,
          horizontal: 16,
          vertical: 10,
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  static _SnackbarConfig _getSnackbarConfig(SnackbarType type) {
    switch (type) {
      case SnackbarType.success:
        return _SnackbarConfig(
          backgroundColor: AppColors.success,
          icon: Icons.check_circle,
        );
      case SnackbarType.error:
        return _SnackbarConfig(
          backgroundColor: const Color(0xFFE53935),
          icon: Icons.error,
        );
      case SnackbarType.info:
        return _SnackbarConfig(
          backgroundColor: const Color(0xFF2196F3),
          icon: Icons.info,
        );
      case SnackbarType.warning:
        return _SnackbarConfig(
          backgroundColor: AppColors.warning,
          icon: Icons.warning,
        );
    }
  }
}

class _SnackbarConfig {
  final Color backgroundColor;
  final IconData icon;

  _SnackbarConfig({required this.backgroundColor, required this.icon});
}
