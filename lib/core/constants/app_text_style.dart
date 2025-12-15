import 'package:flutter/material.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/core/responsive/responsive_text.dart';

class AppTextStyle {
  AppTextStyle._();

  static const String _fontFamily = 'Inter';

  /// BASE STYLES
  /// These should NOT be used directly in UI.
  /// They act as foundations for variants.

  static TextStyle _base({
    required BuildContext context,
    required double fontSize,
    required FontWeight fontWeight,
    required double lineHeight,
    Color? color,
  }) => TextStyle(
    fontFamily: _fontFamily,
    fontWeight: fontWeight,
    fontSize: ResponsiveText.getSize(context, fontSize: fontSize),
    color: color ?? AppColors.textPrimary,
  );

  // headings
  static TextStyle headingRegular(BuildContext context) => _base(
    context: context,
    fontSize: ResponsiveText.getSize(context, fontSize: 24),
    lineHeight: 32,
    fontWeight: FontWeight.w400,
  );

  static TextStyle headingSemiBold(BuildContext context) =>
      headingRegular(context).copyWith(fontWeight: FontWeight.w600);

  // body
  static TextStyle bodyRegular(BuildContext context) => _base(
    context: context,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    lineHeight: 18,
  );

  static TextStyle bodySemiBold(BuildContext context) =>
      bodyRegular(context).copyWith(fontSize: 14, fontWeight: FontWeight.w600);

  static TextStyle bodyMedium(BuildContext context) =>
      bodySemiBold(context).copyWith(fontWeight: FontWeight.w500);

  // Labels
  static TextStyle lableRegular(BuildContext context) => _base(
    context: context,
    fontSize: 10,
    fontWeight: FontWeight.w400,
    lineHeight: 14,
  );

  static TextStyle lableMedium(BuildContext context) =>
      lableRegular(context).copyWith(fontWeight: FontWeight.w500);

  static TextStyle lableBold(BuildContext context) => _base(
    context: context,
    fontSize: 12,
    fontWeight: FontWeight.w700,
    lineHeight: 14,
  );

  static TextStyle lableSemiBold(BuildContext context) => _base(
    context: context,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    lineHeight: 20,
  );
}
