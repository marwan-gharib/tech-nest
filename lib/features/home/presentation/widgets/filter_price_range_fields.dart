import 'package:flutter/material.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/core/utils/extensions/context_extensions.dart';
import 'package:tech_nest/core/widgets/custom_price_field.dart';
import 'package:tech_nest/i18n/strings.g.dart';

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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: CustomPriceField(
              controller: minPrice,
              label: context.t.home.minPrice,
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
              style: context.bodyLarge.copyWith(
                color: context.colors.textSecondary.withValues(
                  alpha: 0.4,
                ),
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          Expanded(
            child: CustomPriceField(
              controller: maxPrice,
              label: context.t.home.maxPrice,
              errorText: maxPriceError,
            ),
          ),
        ],
      ),
    );
  }
}

