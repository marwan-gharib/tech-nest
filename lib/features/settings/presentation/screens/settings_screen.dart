import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tech_nest/core/di/service_locator.dart';
import 'package:tech_nest/core/routing/routes.dart';
import 'package:tech_nest/core/shared/cubits/user_profile/user_profile_cubit.dart';
import 'package:tech_nest/core/theme/app_colors.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/core/theme/app_text_styles.dart';
import 'package:tech_nest/core/theme/cubit/theme_cubit.dart';
import 'package:tech_nest/core/theme/cubit/theme_state.dart';
import 'package:tech_nest/features/settings/presentation/widgets/settings_logout_button.dart';
import 'package:tech_nest/features/settings/presentation/widgets/settings_profile_header.dart';
import 'package:tech_nest/features/settings/presentation/widgets/settings_section.dart';
import 'package:tech_nest/features/settings/presentation/widgets/settings_tile.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings', style: AppTextStyles.headlineMedium),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.md),
              BlocProvider(
                create: (context) => sl<UserProfileCubit>()..loadUser(),
                child: const SettingsProfileHeader(),
              ),
              SettingsSection(
                title: 'Preferences',
                children: [
                  BlocBuilder<ThemeCubit, ThemeState>(
                    builder: (context, state) {
                      final isDark = state.mode == ThemeMode.dark;
                      return SettingsTile(
                        leadingIcon: isDark
                            ? Icons.dark_mode_outlined
                            : Icons.light_mode_outlined,
                        title: 'Dark Mode',
                        trailing: Switch.adaptive(
                          value: isDark,
                          activeThumbColor: Theme.of(context).primaryColor,
                          onChanged: (value) {
                            context.read<ThemeCubit>().toggleTheme();
                          },
                        ),
                      );
                    },
                  ),
                  const SettingsTile(
                    leadingIcon: Icons.notifications_none_rounded,
                    title: 'Notifications',
                  ),
                ],
              ),
              const SettingsSection(
                title: 'More',
                children: [
                  SettingsTile(
                    leadingIcon: Icons.help_outline_rounded,
                    title: 'Help & Support',
                  ),
                  SettingsTile(
                    leadingIcon: Icons.info_outline_rounded,
                    title: 'About App',
                  ),
                ],
              ),
              SettingsLogoutButton(onTap: () => _handleLogout(context)),
              const SizedBox(height: AppSpacing.xl),
              Text(
                'Version 1.0.0',
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.gray400,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }

  void _handleLogout(BuildContext context) {
    // Show confirmation dialog before logout
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // TODO: Call LogoutUsecase via AuthBloc/Cubit
              // sl<LogoutUsecase>().call(NoParams());
              Navigator.pop(context);
              context.go(Routes.loginScreenPath);
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: AppColors.red500),
            ),
          ),
        ],
      ),
    );
  }
}
