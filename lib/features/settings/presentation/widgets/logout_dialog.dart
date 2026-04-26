import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tech_nest/core/theme/app_radius.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/core/utils/extensions/context_extensions.dart';
import 'package:tech_nest/features/settings/presentation/cubits/logout_cubit/logout_cubit.dart';
import 'package:tech_nest/i18n/strings.g.dart';

class LogoutDialog extends StatelessWidget {
  const LogoutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return Dialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(AppRadius.xxl)),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: _dialogDecoration(context),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: AppSpacing.sm,
          children: [
            _logoutIcon(context),
            const SizedBox(height: AppSpacing.sm),
            Text(
              t.settings.logout,
              style: context.headlineSmall.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              t.settings.logoutConfirm,
              textAlign: TextAlign.center,
              style: context.bodyMedium.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                _cancelButton(context),
                const SizedBox(width: AppSpacing.md),
                _logoutButton(context),
              ],
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _dialogDecoration(BuildContext context) {
    return BoxDecoration(
      color: context.colors.surface,
      borderRadius: const BorderRadius.all(Radius.circular(AppRadius.xxl)),
      boxShadow: [
        BoxShadow(
          color: context.colors.textPrimary.withValues(alpha: 0.1),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  Widget _logoutIcon(BuildContext context) {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: context.colors.error.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.logout_rounded,
        color: context.colors.error,
        size: 32,
      ),
    );
  }

  Widget _cancelButton(BuildContext context) {
    return Expanded(
      child: OutlinedButton(
        onPressed: () => context.pop(),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          side: BorderSide(color: context.colors.border),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(AppRadius.xl)),
          ),
        ),
        child: Text(
          context.t.common.cancel,
          style: context.labelLarge.copyWith(color: context.colors.textPrimary),
        ),
      ),
    );
  }

  Widget _logoutButton(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          context.pop();
          context.read<LogoutCubit>().logout();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: context.colors.error,
          foregroundColor: context.colorScheme.onError,
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(AppRadius.xl)),
          ),
        ),
        child: Text(
          context.t.settings.logout,
          style: context.labelLarge.copyWith(
            color: context.colorScheme.onError,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}


