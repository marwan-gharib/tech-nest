import 'package:flutter/material.dart';
import 'package:tech_nest/core/theme/app_colors.dart';
import 'package:tech_nest/core/theme/extentions/app_colors_extension.dart';
import 'package:tech_nest/core/theme/app_radius.dart';
import 'package:tech_nest/core/theme/app_text_styles.dart';

class LightTheme {
  const LightTheme._();

  static const ColorScheme colorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primary,
    onPrimary: AppColors.white,
    secondary: AppColors.slate600,
    onSecondary: AppColors.white,
    tertiary: AppColors.info,
    onTertiary: AppColors.white,
    surface: AppColors.slate50,
    onSurface: AppColors.slate900,
    error: AppColors.error,
    onError: AppColors.white,
    outline: AppColors.slate200,
    outlineVariant: AppColors.slate300,
  );

  static const AppColorsExtension appColorsExtension = AppColorsExtension(
    success: AppColors.success,
    warning: AppColors.warning,
    error: AppColors.error,
    background: AppColors.slate50,
    surface: AppColors.white,
    card: AppColors.white,
    textPrimary: AppColors.slate900,
    textSecondary: AppColors.slate500,
    border: AppColors.slate200,
    divider: AppColors.slate100,
    shimmerBase: AppColors.slate100,
    shimmerHighlight: AppColors.slate50,
  );

  static final ElevatedButtonThemeData elevatedButtonTheme =
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: 0,
          fixedSize: const Size(double.infinity, 52),
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.button),
          textStyle: AppTextStyles.labelLarge.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      );

  static final InputDecorationTheme inputDecorationTheme = InputDecorationTheme(
    filled: true,
    fillColor: AppColors.white,
    hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.slate400),
    errorStyle: AppTextStyles.labelSmall.copyWith(color: AppColors.error),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    border: const OutlineInputBorder(
      borderRadius: AppRadius.input,
      borderSide: BorderSide(color: AppColors.slate200),
    ),
    enabledBorder: const OutlineInputBorder(
      borderRadius: AppRadius.input,
      borderSide: BorderSide(color: AppColors.slate200),
    ),
    focusedBorder: const OutlineInputBorder(
      borderRadius: AppRadius.input,
      borderSide: BorderSide(color: AppColors.primary, width: 1.5),
    ),
    errorBorder: const OutlineInputBorder(
      borderRadius: AppRadius.input,
      borderSide: BorderSide(color: AppColors.error),
    ),
  );

  static final FloatingActionButtonThemeData floatingActionButtonTheme =
      const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        elevation: 4,
        shape: CircleBorder(),
      );

  static final TextTheme textTheme = TextTheme(
    headlineLarge: AppTextStyles.headlineLarge.copyWith(
      color: AppColors.slate900,
    ),
    headlineMedium: AppTextStyles.headlineMedium.copyWith(
      color: AppColors.slate900,
    ),
    bodyLarge: AppTextStyles.bodyLarge.copyWith(color: AppColors.slate900),
    bodyMedium: AppTextStyles.bodyMedium.copyWith(color: AppColors.slate700),
    labelLarge: AppTextStyles.labelLarge.copyWith(color: AppColors.slate900),
    labelMedium: AppTextStyles.labelMedium.copyWith(color: AppColors.slate600),
    labelSmall: AppTextStyles.labelSmall.copyWith(color: AppColors.slate500),
  );

  static final AppBarTheme appBarTheme = AppBarTheme(
    backgroundColor: AppColors.slate50,
    foregroundColor: AppColors.slate900,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: AppTextStyles.headlineMedium.copyWith(
      color: AppColors.slate900,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: const IconThemeData(color: AppColors.slate900),
  );

  static final CardThemeData cardTheme = const CardThemeData(
    color: AppColors.white,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: AppRadius.cardLg,
      side: BorderSide(color: AppColors.slate100),
    ),
  );

  static final BottomNavigationBarThemeData bottomNavigationBarTheme =
      BottomNavigationBarThemeData(
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.slate400,
        selectedLabelStyle: AppTextStyles.labelSmall.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: AppTextStyles.labelSmall,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      );
}
