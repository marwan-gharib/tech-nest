import 'package:tech_nest/core/theme/app_colors.dart';
import 'package:tech_nest/core/theme/mode/light_theme.dart';
import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData get lightTheme => ThemeData(
    brightness: Brightness.light,
    appBarTheme: AppBarTheme(backgroundColor: AppColors.whiteBackground),
    elevatedButtonTheme: LightTheme.elevatedButtonTheme,
    inputDecorationTheme: LightTheme.inputDecorationTheme,
  );
}
