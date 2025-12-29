import 'package:flutter/material.dart';
import 'package:housely/core/responsive/breakpoints.dart';

/// Responsive dimensions for padding, margins, icon sizes, and border radius
/// This ensures consistent scaling across different device sizes
class ResponsiveDimensions {
  ResponsiveDimensions._();

  /// Base reference width
  static final double _baseWidth = Breakpoints.smallPhone;
  static final double _baseHeight = Breakpoints.smallPhoneHeight;

  /// Get scale factor based on screen width
  static double _getScaleFactor(BuildContext context) {
    double screenWidth = MediaQuery.widthOf(context);
    double scaleFactor = screenWidth / _baseWidth;
    // Clamp between 0.85 and 1.15 to prevent extreme scaling
    return scaleFactor.clamp(0.85, 1.15);
  }

  /// Get scale factor based on screen height
  static double _getHeightScaleFactor(BuildContext context) {
    double screenHeight = MediaQuery.heightOf(context);
    double scaleFactor = screenHeight / _baseHeight;

    return scaleFactor.clamp(0.35, 1.15);
  }

  /// Get responsive size for any dimension (padding, margin, icon size, and width etc.)
  static double getSize(BuildContext context, double size) {
    return size * _getScaleFactor(context);
  }

  /// Get responsive height
  static double getHeight(BuildContext context, double size) {
    return size * _getHeightScaleFactor(context);
  }

  // ==================== SPACING/PADDING ====================

  /// Spacing scale based on 4px base unit
  static double spacing4(BuildContext context) => getSize(context, 4);
  static double spacing8(BuildContext context) => getSize(context, 8);
  static double spacing12(BuildContext context) => getSize(context, 12);
  static double spacing16(BuildContext context) => getSize(context, 16);
  static double spacing20(BuildContext context) => getSize(context, 20);
  static double spacing24(BuildContext context) => getSize(context, 24);
  static double spacing32(BuildContext context) => getSize(context, 32);
  static double spacing40(BuildContext context) => getSize(context, 40);
  static double spacing48(BuildContext context) => getSize(context, 48);

  /// Common padding presets
  static EdgeInsets paddingAll4(BuildContext context) =>
      EdgeInsets.all(spacing4(context));

  static EdgeInsets paddingAll8(BuildContext context) =>
      EdgeInsets.all(spacing8(context));

  static EdgeInsets paddingAll12(BuildContext context) =>
      EdgeInsets.all(spacing12(context));

  static EdgeInsets paddingAll16(BuildContext context) =>
      EdgeInsets.all(spacing16(context));

  static EdgeInsets paddingAll24(BuildContext context) =>
      EdgeInsets.all(spacing24(context));

  /// Horizontal padding
  static EdgeInsets paddingH8(BuildContext context) =>
      EdgeInsets.symmetric(horizontal: spacing8(context));

  static EdgeInsets paddingH12(BuildContext context) =>
      EdgeInsets.symmetric(horizontal: spacing12(context));

  static EdgeInsets paddingH16(BuildContext context) =>
      EdgeInsets.symmetric(horizontal: spacing16(context));

  static EdgeInsets paddingH24(BuildContext context) =>
      EdgeInsets.symmetric(horizontal: spacing24(context));

  /// Vertical padding
  static EdgeInsets paddingV8(BuildContext context) =>
      EdgeInsets.symmetric(vertical: spacing8(context));

  static EdgeInsets paddingV12(BuildContext context) =>
      EdgeInsets.symmetric(vertical: spacing12(context));

  static EdgeInsets paddingV16(BuildContext context) =>
      EdgeInsets.symmetric(vertical: spacing16(context));

  static EdgeInsets paddingV24(BuildContext context) =>
      EdgeInsets.symmetric(vertical: spacing24(context));

  /// Custom padding
  static EdgeInsets paddingSymmetric(
    BuildContext context, {
    double horizontal = 0,
    double vertical = 0,
  }) => EdgeInsets.symmetric(
    horizontal: getHeight(context, horizontal),
    vertical: getSize(context, vertical),
  );

  static EdgeInsets paddingOnly(
    BuildContext context, {
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) => EdgeInsets.only(
    left: getSize(context, left),
    top: getSize(context, top),
    right: getSize(context, right),
    bottom: getSize(context, bottom),
  );

  // ==================== ICON SIZES ====================

  static double iconXSmall(BuildContext context) => getSize(context, 16);
  static double iconMedium(BuildContext context) => getSize(context, 24);

  // ==================== BORDER RADIUS ====================

  /// default size : 8
  static double radiusSmall(BuildContext context, {double? size}) =>
      getSize(context, size ?? 8);

  /// default size : 12
  static double radiusMedium(BuildContext context, {double? size}) =>
      getSize(context, size ?? 12);

  /// default size : 16
  static double radiusLarge(BuildContext context, {double? size}) =>
      getSize(context, size ?? 16);

  /// default size : 24
  static double radiusXLarge(BuildContext context, {double? size}) =>
      getSize(context, size ?? 24);

  /// Defaul radius size: 8
  static BorderRadius borderRadiusSmall(BuildContext context, {double? size}) =>
      BorderRadius.circular(radiusSmall(context, size: size));

  /// Defaul radius size: 12
  static BorderRadius borderRadiusMedium(
    BuildContext context, {
    double? size,
  }) => BorderRadius.circular(radiusMedium(context, size: size));

  /// Defaul radius size: 16
  static BorderRadius borderRadiusLarge(BuildContext context, {double? size}) =>
      BorderRadius.circular(radiusLarge(context, size: size));

  /// Defaul radius size: 24
  static BorderRadius borderRadiusXLarge(
    BuildContext context, {
    double? size,
  }) => BorderRadius.circular(radiusXLarge(context, size: size));

  /// Only top corners
  static BorderRadius borderRadiusTopMedium(BuildContext context) =>
      BorderRadius.only(
        topLeft: Radius.circular(radiusMedium(context)),
        topRight: Radius.circular(radiusMedium(context)),
      );

  static BorderRadius borderRadiusTopLarge(BuildContext context) =>
      BorderRadius.only(
        topLeft: Radius.circular(radiusLarge(context)),
        topRight: Radius.circular(radiusLarge(context)),
      );

  // ==================== BUTTON SIZES ====================

  static double buttonHeight(BuildContext context, {double? buttonHeight}) =>
      getSize(context, buttonHeight ?? 52);

  // ==================== AVATAR SIZES ====================
  static double avatarMedium(BuildContext context) => getSize(context, 44);
  static double avatarLarge(BuildContext context) => getSize(context, 52);
  static double avatarXLarge(BuildContext context) => getSize(context, 100);
  static double avatarXXLarge(BuildContext context) => getSize(context, 208);

  // ==================== APP BAR & BOTTOM NAV ====================

  static double appBarHeight(BuildContext context) => getSize(context, 24);
  static double bottomNavHeight(BuildContext context) => getSize(context, 86);

  // ==================== GAP/SIZED BOX HELPERS ====================

  static SizedBox gapH4(BuildContext context) =>
      SizedBox(height: spacing4(context));

  static SizedBox gapH8(BuildContext context) =>
      SizedBox(height: spacing8(context));

  static SizedBox gapH12(BuildContext context) =>
      SizedBox(height: spacing12(context));

  static SizedBox gapH16(BuildContext context) =>
      SizedBox(height: spacing16(context));

  static SizedBox gapH24(BuildContext context) =>
      SizedBox(height: spacing24(context));

  static SizedBox gapH32(BuildContext context) =>
      SizedBox(height: spacing32(context));

  static SizedBox gapW4(BuildContext context) =>
      SizedBox(width: spacing4(context));

  static SizedBox gapW8(BuildContext context) =>
      SizedBox(width: spacing8(context));

  static SizedBox gapW12(BuildContext context) =>
      SizedBox(width: spacing12(context));

  static SizedBox gapW16(BuildContext context) =>
      SizedBox(width: spacing16(context));

  static SizedBox gapW24(BuildContext context) =>
      SizedBox(width: spacing24(context));
}
