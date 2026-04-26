import 'package:flutter/material.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/core/utils/extensions/context_extensions.dart';
import 'package:tech_nest/i18n/strings.g.dart';

class AppVersionText extends StatelessWidget {
  final String version;

  const AppVersionText({super.key, this.version = '1.0.0'});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
      child: Text(
        context.t.settings.version(version: version),
        style: context.labelSmall.copyWith(
          color: context.colors.textSecondary,
        ),
      ),
    );
  }
}

