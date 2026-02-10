import 'package:tech_nest/core/theme/app_colors.dart';
import 'package:tech_nest/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class LightTheme {
  const LightTheme._();

  static ElevatedButtonThemeData get elevatedButtonTheme => ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      elevation: 10,
      fixedSize: Size(double.infinity, 50),
    ),
  );

  static final OutlineInputBorder _commonBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(6),
    borderSide: BorderSide(color: AppColors.enabledBorder, width: 1),
    gapPadding: 10,
  );

  static InputDecorationThemeData get inputDecorationTheme => InputDecorationThemeData(
    errorStyle: AppTextStyles.errorStyle,
    enabledBorder: _commonBorder,
    errorBorder: _commonBorder,
    focusedErrorBorder: _commonBorder,
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: BorderSide(color: AppColors.focusedBorder, width: 2),
      gapPadding: 10,
    ),
  );
}
