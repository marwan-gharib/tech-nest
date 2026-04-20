import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_nest/core/constants/links.dart';
import 'package:tech_nest/core/di/service_locator.dart';
import 'package:tech_nest/core/shared/utils/lanch_url.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/core/theme/cubit/theme_cubit.dart';
import 'package:tech_nest/core/theme/cubit/theme_state.dart';
import 'package:tech_nest/features/settings/presentation/cubits/logout_cubit/logout_cubit.dart';
import 'package:tech_nest/features/settings/presentation/cubits/user_profile/user_profile_cubit.dart';
import 'package:tech_nest/features/settings/presentation/widgets/settings_logout_button.dart';
import 'package:tech_nest/features/settings/presentation/widgets/settings_profile_header.dart';
import 'package:tech_nest/features/settings/presentation/widgets/settings_section.dart';
import 'package:tech_nest/features/settings/presentation/widgets/settings_tile.dart';
import 'package:tech_nest/core/shared/presentation/cubits/locale/locale_cubit.dart';
import 'package:tech_nest/i18n/strings.g.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.t.settings.title,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
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
                title: context.t.settings.preferences,
                children: [
                  BlocBuilder<ThemeCubit, ThemeState>(
                    builder: (context, state) {
                      final isDark = state.mode == ThemeMode.dark;
                      return SettingsTile(
                        leadingIcon: isDark
                            ? Icons.dark_mode_outlined
                            : Icons.light_mode_outlined,
                        title: context.t.settings.darkMode,
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
                  SettingsTile(
                    leadingIcon: Icons.language_rounded,
                    title: context.t.settings.language,
                    trailing: BlocBuilder<LocaleCubit, LocaleState>(
                      builder: (context, state) {
                        return SegmentedButton<AppLocale>(
                          style: SegmentedButton.styleFrom(
                            visualDensity: VisualDensity.compact,
                            textStyle: Theme.of(context).textTheme.labelMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          showSelectedIcon: false,
                          segments: const [
                            ButtonSegment(
                              value: AppLocale.en,
                              label: Text('EN', textAlign: TextAlign.center),
                            ),
                            ButtonSegment(
                              value: AppLocale.ar,
                              label: Text('عربي', textAlign: TextAlign.center),
                            ),
                          ],
                          selected: {state.locale},
                          onSelectionChanged: (Set<AppLocale> newSelection) {
                            if (newSelection.isNotEmpty) {
                              context.read<LocaleCubit>().setLocale(
                                newSelection.first,
                              );
                            }
                          },
                        );
                      },
                    ),
                  ),
                  SettingsTile(
                    leadingIcon: Icons.notifications_none_rounded,
                    title: context.t.settings.notifications,
                  ),
                ],
              ),
              SettingsSection(
                title: context.t.settings.more,
                children: [
                  SettingsTile(
                    leadingIcon: Icons.help_outline_rounded,
                    title: context.t.settings.help,
                    onTap: () => LanchUrl.launch(Links.helpAndSupport),
                  ),
                  SettingsTile(
                    leadingIcon: Icons.info_outline_rounded,
                    title: context.t.settings.about,
                    onTap: () => LanchUrl.launch(Links.aboutApp),
                  ),
                ],
              ),
              BlocProvider(
                create: (context) => sl<LogoutCubit>(),
                child: SettingsLogoutButton(),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                context.t.settings.version(version: '1.0.0'),
                style: Theme.of(context).textTheme.labelSmall!.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }
}
