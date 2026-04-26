import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_nest/core/cubits/theme_cubit/theme_cubit.dart';
import 'package:tech_nest/core/cubits/theme_cubit/theme_state.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/core/utils/extensions/context_extensions.dart';
import 'package:tech_nest/features/settings/presentation/widgets/theme_option.dart';
import 'package:tech_nest/i18n/strings.g.dart';

class ThemeSelector extends StatelessWidget {
  const ThemeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.t.settings.theme,
                style: context.titleSmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.colorScheme.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: ThemeOption(
                      mode: ThemeMode.system,
                      icon: Icons.brightness_auto_rounded,
                      label: context.t.settings.systemMode,
                      isSelected: state.mode == ThemeMode.system,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: ThemeOption(
                      mode: ThemeMode.light,
                      icon: Icons.light_mode_rounded,
                      label: context.t.settings.lightMode,
                      isSelected: state.mode == ThemeMode.light,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: ThemeOption(
                      mode: ThemeMode.dark,
                      icon: Icons.dark_mode_rounded,
                      label: context.t.settings.darkMode,
                      isSelected: state.mode == ThemeMode.dark,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

