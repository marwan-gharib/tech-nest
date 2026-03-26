import 'package:flutter/material.dart';
import 'package:tech_nest/core/theme/app_colors.dart';
import 'package:tech_nest/core/theme/app_radius.dart';
import 'package:tech_nest/core/theme/app_text_styles.dart';

class DarkTheme {
  const DarkTheme._();

  static const ColorScheme colorScheme = ColorScheme(
    brightness: Brightness.dark,

    primary: AppColors.blue600,
    onPrimary: AppColors.white,

    secondary: AppColors.gray400,
    onSecondary: AppColors.black,

    tertiary: AppColors.teal500,
    onTertiary: AppColors.black,

    surface: AppColors.gray900,
    onSurface: AppColors.gray100,

    surfaceContainerHighest: AppColors.gray800,
    onSurfaceVariant: AppColors.gray300,

    error: AppColors.red500,
    onError: AppColors.white,

    outline: AppColors.gray700,
    outlineVariant: AppColors.gray400,

    inverseSurface: AppColors.gray100,
    onInverseSurface: AppColors.gray900,

    tertiaryFixed: AppColors.orange500,
  );

  static final ElevatedButtonThemeData elevatedButtonTheme =
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          disabledBackgroundColor: colorScheme.primary.withValues(alpha: 0.4),
          disabledForegroundColor: colorScheme.onPrimary.withValues(alpha: 0.6),
          elevation: 4,
          fixedSize: const Size(double.infinity, 50),
        ),
      );

  static final OutlineInputBorder _enabledBorder = OutlineInputBorder(
    borderRadius: AppRadius.input,
    borderSide: BorderSide(color: colorScheme.outline, width: 1),
  );

  static final OutlineInputBorder _focusedBorder = OutlineInputBorder(
    borderRadius: AppRadius.input,
    borderSide: BorderSide(color: colorScheme.primary, width: 2),
  );

  static final OutlineInputBorder _errorBorder = OutlineInputBorder(
    borderRadius: AppRadius.input,
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
        elevation: 0,
        highlightElevation: 0,
      );

  static final TextTheme textTheme = const TextTheme(
    headlineLarge: AppTextStyles.headlineLarge,
    headlineMedium: AppTextStyles.headlineMedium,
    bodyLarge: AppTextStyles.bodyLarge,
    bodyMedium: AppTextStyles.bodyMedium,
    labelLarge: AppTextStyles.labelLarge,
    labelMedium: AppTextStyles.labelMedium,
    labelSmall: AppTextStyles.labelSmall,
  ).apply(
    bodyColor: colorScheme.onSurface,
    displayColor: colorScheme.onSurface,
  );

  static final AppBarTheme appBarTheme = AppBarTheme(
    backgroundColor: colorScheme.surface,
    centerTitle: true,
    elevation: 0,
    titleTextStyle: AppTextStyles.headlineMedium.copyWith(
      color: colorScheme.onSurface,
    ),
    iconTheme: IconThemeData(color: colorScheme.onSurface),
  );

  static final CardThemeData cardTheme = CardThemeData(
    color: colorScheme.surfaceContainerHighest,
    shadowColor: colorScheme.onSurfaceVariant,
    elevation: 1.5,
    shape: RoundedRectangleBorder(borderRadius: AppRadius.cardLg),
  );
  
  static final IconThemeData iconTheme = const IconThemeData();

  static final BottomNavigationBarThemeData bottomNavigationBarTheme = BottomNavigationBarThemeData(
    backgroundColor: colorScheme.surface,
    selectedIconTheme: IconThemeData(color: colorScheme.primary, size: 28),
    unselectedIconTheme: IconThemeData(color: colorScheme.onSurfaceVariant),
    selectedLabelStyle: textTheme.labelSmall?.copyWith(
      color: colorScheme.primary,
    ),
    unselectedLabelStyle: textTheme.labelSmall?.copyWith(
      color: colorScheme.onSurfaceVariant,
    ),
    selectedItemColor: colorScheme.primary,
    unselectedItemColor: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
    type: BottomNavigationBarType.shifting,
    landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
    elevation: 10,
    showSelectedLabels: true,
  );
}
