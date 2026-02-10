import 'package:tech_nest/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AppTextStyles {
  const AppTextStyles._();

  static const headline = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryText,
  );

  static const lable = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.seconderyText,
  );

  static const special = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.special,
  );

  static const hintStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.hintText,
  );

  static const errorStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.error,
  );

  static const buttonStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textButton,
  );

  static const linkStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
  );
}
