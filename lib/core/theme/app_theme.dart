import 'package:flutter/material.dart';
import 'package:tech_nest/core/theme/app_colors.dart';
import 'package:tech_nest/core/theme/modes/dark.dart';
import 'package:tech_nest/core/theme/modes/light.dart';

class AppTheme {
  const AppTheme._();

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: LightTheme.colorScheme.primary,
    scaffoldBackgroundColor: LightTheme.colorScheme.surface,
    colorScheme: LightTheme.colorScheme,
    appBarTheme: LightTheme.appBarTheme,
    useMaterial3: true,
    textTheme: LightTheme.textTheme,
    elevatedButtonTheme: LightTheme.elevatedButtonTheme,
    inputDecorationTheme: LightTheme.inputDecorationTheme,
    floatingActionButtonTheme: LightTheme.floatingActionButtonTheme,
    cardTheme: LightTheme.cardTheme,
    shadowColor: AppColors.black,
    hintColor: LightTheme.colorScheme.onSurface.withValues(alpha: 0.3),
    bottomNavigationBarTheme: LightTheme.bottomNavigationBarTheme,
    extensions: const [LightTheme.appColorsExtension],
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: DarkTheme.colorScheme.primary,
    scaffoldBackgroundColor: DarkTheme.appColorsExtension.background,
    colorScheme: DarkTheme.colorScheme,
    appBarTheme: DarkTheme.appBarTheme,
    useMaterial3: true,
    textTheme: DarkTheme.textTheme,
    elevatedButtonTheme: DarkTheme.elevatedButtonTheme,
    inputDecorationTheme: DarkTheme.inputDecorationTheme,
    floatingActionButtonTheme: DarkTheme.floatingActionButtonTheme,
    cardTheme: DarkTheme.cardTheme,
    shadowColor: AppColors.white,
    hintColor: DarkTheme.colorScheme.onSurface.withValues(alpha: 0.3),
    bottomNavigationBarTheme: DarkTheme.bottomNavigationBarTheme,
    extensions: const [DarkTheme.appColorsExtension],
  );
}
