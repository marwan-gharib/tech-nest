import 'package:flutter/material.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';

class FilterSectionHeader extends StatelessWidget {
  final String label;
  const FilterSectionHeader({required this.label, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const double indent = 8.0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        children: [
          Expanded(
            child: Divider(
              endIndent: indent,
              color: theme.colorScheme.primary,
              thickness: 1.5,
            ),
          ),
          Text(
            label,
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Divider(
              indent: indent,
              color: theme.colorScheme.primary,
              thickness: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
