import 'package:flutter/material.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/i18n/strings.g.dart';

class ProductDescriptionSection extends StatelessWidget {
  final String description;
  const ProductDescriptionSection({required this.description, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.xs,
      children: [
        Text(
          context.t.products.description,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          description,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.shadowColor.withValues(alpha: 0.7),
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
