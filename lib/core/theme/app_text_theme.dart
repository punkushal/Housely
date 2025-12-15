import 'package:flutter/material.dart';
import 'package:housely/core/constants/app_text_style.dart';

class AppTextTheme {
  AppTextTheme._();

  static TextTheme of(BuildContext context) {
    return TextTheme(
      // Headlines
      headlineLarge: AppTextStyle.headingRegular(context),
      headlineMedium: AppTextStyle.headingSemiBold(context),

      // Body
      bodyLarge: AppTextStyle.bodySemiBold(context),
      bodyMedium: AppTextStyle.bodyRegular(context),

      // Labels
      labelLarge: AppTextStyle.lableSemiBold(context),
      labelMedium: AppTextStyle.lableMedium(context),
      labelSmall: AppTextStyle.lableRegular(context),
    );
  }
}
