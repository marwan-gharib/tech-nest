import 'package:flutter/material.dart';
import 'package:tech_nest/core/theme/app_colors.dart';
import 'package:tech_nest/core/theme/app_radius.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/core/theme/app_text_styles.dart';

class SettingsLogoutButton extends StatelessWidget {
  final VoidCallback onTap;

  const SettingsLogoutButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: AppSpacing.xxl),
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: const Icon(Icons.logout_rounded, color: AppColors.red500),
        label: Text(
          'Logout',
          style: AppTextStyles.labelLarge.copyWith(
            color: AppColors.red500,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          side: const BorderSide(color: AppColors.red500, width: 1.5),
          shape: const RoundedRectangleBorder(
            borderRadius: AppRadius.button,
          ),
        ),
      ),
    );
  }
}
