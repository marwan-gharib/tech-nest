import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tech_nest/service_locator.dart';
import 'package:tech_nest/core/routing/routes.dart';
import 'package:tech_nest/features/auth/presentation/notifiers/auth_notifier.dart';
import 'package:tech_nest/core/widgets/custom_snack_bar.dart';
import 'package:tech_nest/core/utils/logger.dart';
import 'package:tech_nest/core/theme/app_radius.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/features/settings/presentation/cubits/logout_cubit/logout_cubit.dart';
import 'package:tech_nest/features/settings/presentation/widgets/logout_dialog.dart';
import 'package:tech_nest/i18n/strings.g.dart';

class SettingsLogoutButton extends StatelessWidget {
  SettingsLogoutButton({super.key});

  final AuthNotifier _authNotifier = sl<AuthNotifier>();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: AppSpacing.xxl),
      child: BlocConsumer<LogoutCubit, LogoutState>(
        listener: _listener,
        builder: _builder,
      ),
    );
  }

  void _listener(BuildContext context, LogoutState state) {
    if (state is LogoutSuccess) {
      context.go(Routes.loginScreenPath);
      AppLogger.log("asfocjs fclksasdcsc sdkcnscl 11111111111111");
      _authNotifier.logout();
      AppLogger.log("asfocjs fclksasdcsc sdkcnscl 22222222222222");
    } else if (state is LogoutFailure) {
      CustomSnackBar.showError(context, failure: state.failure);
    }
  }

  Widget _builder(BuildContext context, LogoutState state) {
    final theme = Theme.of(context);

    if (state is LogoutLoading) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        decoration: BoxDecoration(
          borderRadius: AppRadius.button,
          color: theme.colorScheme.error.withValues(alpha: 0.1),
        ),
        child: Center(
          child: CircularProgressIndicator(color: theme.colorScheme.error),
        ),
      );
    }
    return OutlinedButton.icon(
      onPressed: () => _handleLogout(context),
      icon: Icon(Icons.logout_rounded, color: theme.colorScheme.error),
      label: Text(
        context.t.auth.logout,
        style: theme.textTheme.labelLarge?.copyWith(
          color: theme.colorScheme.error,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        side: BorderSide(color: theme.colorScheme.error, width: 1.5),
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.button),
      ),
    );
  }

  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<LogoutCubit>(),
        child: const LogoutDialog(),
      ),
    );
  }
}
