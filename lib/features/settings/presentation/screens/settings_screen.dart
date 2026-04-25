import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_nest/core/constants/links.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/core/utils/lanch_url.dart';
import 'package:tech_nest/features/settings/presentation/cubits/logout_cubit/logout_cubit.dart';
import 'package:tech_nest/features/settings/presentation/cubits/user_profile/user_profile_cubit.dart';
import 'package:tech_nest/features/settings/presentation/widgets/app_version_text.dart';
import 'package:tech_nest/features/settings/presentation/widgets/language_selector_tile.dart';
import 'package:tech_nest/features/settings/presentation/widgets/settings_logout_button.dart';
import 'package:tech_nest/features/settings/presentation/widgets/settings_profile_header.dart';
import 'package:tech_nest/features/settings/presentation/widgets/settings_section.dart';
import 'package:tech_nest/features/settings/presentation/widgets/settings_tile.dart';
import 'package:tech_nest/features/settings/presentation/widgets/theme_selector.dart';
import 'package:tech_nest/i18n/strings.g.dart';
import 'package:tech_nest/service_locator.dart';

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
                  const ThemeSelector(),
                  const LanguageSelectorTile(),
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
              const AppVersionText(),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }
}
