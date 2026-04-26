import 'package:flutter/material.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/core/utils/extensions/context_extensions.dart';
import 'package:tech_nest/i18n/strings.g.dart';

class ProductDescriptionSection extends StatelessWidget {
  final String description;
  const ProductDescriptionSection({required this.description, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.xs,
      children: [
        Text(
          context.t.products.description,
          style: context.titleLarge.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          description,
          style: context.bodyMedium.copyWith(
            color: context.colors.textSecondary,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

