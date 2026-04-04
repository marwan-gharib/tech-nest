import 'package:flutter/material.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/core/theme/app_text_styles.dart';
import 'package:tech_nest/features/home/presentation/widgets/custom_price_field.dart';

class FilterPriceRangeFields extends StatelessWidget {
  final TextEditingController minPrice;
  final TextEditingController maxPrice;
  final String? minPriceError;
  final String? maxPriceError;

  const FilterPriceRangeFields({
    required this.minPrice,
    required this.maxPrice,
    this.minPriceError,
    this.maxPriceError,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: CustomPriceField(
              controller: minPrice,
              label: 'Min price',
              errorText: minPriceError,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: AppSpacing.sm,
              right: AppSpacing.sm,
              top: 20, // Align dash with input center
            ),
            child: Text(
              '—',
              style: AppTextStyles.bodyLarge.copyWith(
                color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          Expanded(
            child: CustomPriceField(
              controller: maxPrice,
              label: 'Max price',
              errorText: maxPriceError,
            ),
          ),
        ],
      ),
    );
  }
}
