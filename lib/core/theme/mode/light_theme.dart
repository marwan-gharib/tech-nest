import 'package:flutter/material.dart';
import 'package:tech_nest/core/theme/app_colors.dart';
import 'package:tech_nest/core/theme/app_text_styles.dart';

class LightTheme {
  const LightTheme._();

  static const ColorScheme colorScheme = ColorScheme(
    brightness: Brightness.light,

    primary: AppColors.blue600,
    onPrimary: AppColors.white,

    secondary: AppColors.gray700,
    onSecondary: AppColors.white,

    tertiary: AppColors.teal500,
    onTertiary: AppColors.white,

    surface: AppColors.gray50,
    onSurface: AppColors.gray900,

    surfaceContainerHighest: AppColors.white,
    onSurfaceVariant: AppColors.gray800,

    error: AppColors.red500,
    onError: AppColors.white,

    outline: AppColors.gray300,
    outlineVariant: AppColors.gray400,

    inverseSurface: AppColors.gray900,
    onInverseSurface: AppColors.white,

    tertiaryFixed: AppColors.orange500,
  );

  static final ElevatedButtonThemeData elevatedButtonTheme =
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          disabledBackgroundColor: colorScheme.primary.withValues(alpha: 0.5),
          disabledForegroundColor: colorScheme.onPrimary.withValues(alpha: 0.5),
          elevation: 10,
          fixedSize: const Size(double.infinity, 50),
        ),
      );

  static final OutlineInputBorder _enabledBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(6),
    borderSide: BorderSide(color: colorScheme.outline, width: 1),
  );

  static final OutlineInputBorder _focusedBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(6),
    borderSide: BorderSide(color: colorScheme.primary, width: 2),
  );

  static final OutlineInputBorder _errorBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(6),
    borderSide: BorderSide(color: colorScheme.error, width: 1.5),
  );

  static final InputDecorationTheme inputDecorationTheme = InputDecorationTheme(
    hintStyle: textTheme.bodyMedium!.copyWith(
      color: colorScheme.onSurfaceVariant,
    ),
    errorStyle: textTheme.bodyMedium!.copyWith(color: colorScheme.error),
    enabledBorder: _enabledBorder,
    focusedBorder: _focusedBorder,
    errorBorder: _errorBorder,
    focusedErrorBorder: _errorBorder,
  );

  static final FloatingActionButtonThemeData floatingActionButtonTheme =
      FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        shape: const CircleBorder(),
        iconSize: 26,
      );

  static const TextTheme textTheme = TextTheme(
    headlineLarge: AppTextStyles.headlineLarge,
    headlineMedium: AppTextStyles.headlineMedium,
    bodyLarge: AppTextStyles.bodyLarge,
    bodyMedium: AppTextStyles.bodyMedium,
    labelLarge: AppTextStyles.labelLarge,
    labelMedium: AppTextStyles.labelMedium,
    labelSmall: AppTextStyles.labelSmall,
  );

  static final AppBarTheme appBarTheme = AppBarTheme(
    backgroundColor: colorScheme.surface,
    centerTitle: true,
    titleTextStyle: AppTextStyles.headlineMedium.copyWith(
      color: colorScheme.onSurface,
    ),
  );

  static final CardThemeData cardTheme = CardThemeData(
    color: colorScheme.surfaceContainerHighest,
    shadowColor: colorScheme.onSurfaceVariant,
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  );
}
