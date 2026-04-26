import 'package:flutter/material.dart';
import 'package:tech_nest/core/theme/app_colors.dart';
import 'package:tech_nest/core/theme/app_radius.dart';
import 'package:tech_nest/core/theme/app_text_styles.dart';
import 'package:tech_nest/core/theme/extensions/app_colors_extension.dart';

class DarkTheme {
  const DarkTheme._();

  static const ColorScheme colorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.primary,
    onPrimary: AppColors.white,
    secondary: AppColors.slate400,
    onSecondary: AppColors.slate950,
    tertiary: AppColors.info,
    onTertiary: AppColors.white,
    surface: AppColors.slate900,
    onSurface: AppColors.slate50,
    error: AppColors.error,
    onError: AppColors.white,
    outline: AppColors.slate700,
    outlineVariant: AppColors.slate800,
  );

  static const AppColorsExtension appColorsExtension = AppColorsExtension(
    success: AppColors.success,
    warning: AppColors.warning,
    error: AppColors.error,
    info: AppColors.info,
    background: AppColors.slate950,
    surface: AppColors.slate900,
    card: AppColors.slate900,
    textPrimary: AppColors.slate50,
    textSecondary: AppColors.slate400,
    border: AppColors.slate800,
    divider: AppColors.slate800,
    shimmerBase: AppColors.slate800,
    shimmerHighlight: AppColors.slate700,
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
    fillColor: AppColors.slate900,
    hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.slate500),
    errorStyle: AppTextStyles.labelSmall.copyWith(color: AppColors.error),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    border: const OutlineInputBorder(
      borderRadius: AppRadius.input,
      borderSide: BorderSide(color: AppColors.slate800),
    ),
    enabledBorder: const OutlineInputBorder(
      borderRadius: AppRadius.input,
      borderSide: BorderSide(color: AppColors.slate800),
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
      color: AppColors.slate50,
    ),
    headlineMedium: AppTextStyles.headlineMedium.copyWith(
      color: AppColors.slate50,
    ),
    bodyLarge: AppTextStyles.bodyLarge.copyWith(color: AppColors.slate100),
    bodyMedium: AppTextStyles.bodyMedium.copyWith(color: AppColors.slate300),
    labelLarge: AppTextStyles.labelLarge.copyWith(color: AppColors.slate50),
    labelMedium: AppTextStyles.labelMedium.copyWith(color: AppColors.slate400),
    labelSmall: AppTextStyles.labelSmall.copyWith(color: AppColors.slate500),
  );

  static final AppBarTheme appBarTheme = AppBarTheme(
    backgroundColor: AppColors.slate950,
    foregroundColor: AppColors.slate50,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: AppTextStyles.headlineMedium.copyWith(
      color: AppColors.slate50,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: const IconThemeData(color: AppColors.slate50),
  );

  static final CardThemeData cardTheme = const CardThemeData(
    color: AppColors.slate900,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: AppRadius.cardLg,
      side: BorderSide(color: AppColors.slate800),
    ),
  );

  static final BottomNavigationBarThemeData bottomNavigationBarTheme =
      BottomNavigationBarThemeData(
        backgroundColor: AppColors.slate950,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.slate600,
        selectedLabelStyle: AppTextStyles.labelSmall.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: AppTextStyles.labelSmall,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      );
}
