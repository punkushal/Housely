import 'package:flutter/material.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/core/constants/app_text_style.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';
import 'package:housely/core/theme/app_text_theme.dart';

class AppTheme {
  AppTheme._();

  static ThemeData light(BuildContext context) {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Inter',

      // color scheme theme
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.primary,
        onPrimary: AppColors.background,
        secondary: AppColors.primarySoft,
        onSecondary: AppColors.textPrimary,
        error: AppColors.error,
        onError: AppColors.background,
        surface: AppColors.surface,
        onSurface: AppColors.textPrimary,
      ),
      // text theme
      textTheme: AppTextTheme.of(context),
      // scaffold
      scaffoldBackgroundColor: AppColors.surface,

      // App Bar Theme
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        centerTitle: true,
        titleTextStyle: AppTextStyle.bodySemiBold(
          context,
        ).copyWith(fontSize: 16, height: 24 / 16),
        iconTheme: IconThemeData(color: AppColors.textPrimary, size: 24),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.background,
          minimumSize: Size(
            double.infinity,
            ResponsiveDimensions.buttonHeight(context),
          ),
          padding: ResponsiveDimensions.paddingSymmetric(
            context,
            horizontal: 24,
            vertical: 8,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: ResponsiveDimensions.borderRadiusSmall(context),
          ),
          textStyle: AppTextStyle.bodyRegular(
            context,
          ).copyWith(fontSize: 18, height: 27 / 18),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: ResponsiveDimensions.borderRadiusMedium(context),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: ResponsiveDimensions.borderRadiusMedium(context),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: ResponsiveDimensions.borderRadiusMedium(context),
          borderSide: const BorderSide(color: AppColors.primaryPressed),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: ResponsiveDimensions.borderRadiusMedium(context),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: ResponsiveDimensions.borderRadiusMedium(context),
          borderSide: const BorderSide(color: AppColors.error),
        ),

        hintStyle: AppTextStyle.bodyRegular(
          context,
        ).copyWith(color: AppColors.textHint),
        errorStyle: AppTextStyle.bodyRegular(
          context,
        ).copyWith(color: AppColors.error),

        suffixIconColor: AppColors.textHint,
      ),

      // Checkbox Theme
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primaryPressed;
          }
          return AppColors.surface;
        }),
        checkColor: WidgetStateProperty.all(AppColors.surface),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        side: BorderSide(color: AppColors.textSecondary),
      ),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: 1,
      ),
    );
  }
}
