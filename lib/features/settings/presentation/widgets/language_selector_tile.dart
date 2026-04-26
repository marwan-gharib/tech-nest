import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_nest/core/cubits/locale_cubit/locale_cubit.dart';
import 'package:tech_nest/core/utils/extensions/context_extensions.dart';
import 'package:tech_nest/features/settings/presentation/widgets/settings_tile.dart';
import 'package:tech_nest/i18n/strings.g.dart';

class LanguageSelectorTile extends StatelessWidget {
  const LanguageSelectorTile({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsTile(
      leadingIcon: Icons.language_rounded,
      title: context.t.settings.language,
      trailing: BlocBuilder<LocaleCubit, LocaleState>(
        builder: (context, state) {
          return SegmentedButton<AppLocale>(
            style: SegmentedButton.styleFrom(
              visualDensity: VisualDensity.compact,
              textStyle: context.labelMedium.copyWith(fontWeight: FontWeight.bold),
            ),
            showSelectedIcon: false,
            segments: [
              ButtonSegment(
                value: AppLocale.en,
                label: Text(context.t.settings.english, textAlign: TextAlign.center),
              ),
              ButtonSegment(
                value: AppLocale.ar,
                label: Text(context.t.settings.arabic, textAlign: TextAlign.center),
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
    );
  }
}

