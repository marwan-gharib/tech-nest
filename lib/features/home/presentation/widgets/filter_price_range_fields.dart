import 'package:flutter/material.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/features/home/presentation/widgets/custom_price_field.dart';

class FilterPriceRangeFields extends StatelessWidget {
  final TextEditingController minPrice;
  final TextEditingController maxPrice;

  const FilterPriceRangeFields({
    required this.minPrice,
    required this.maxPrice,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.xs,
      ),
      child: Row(
        spacing: AppSpacing.lg,
        children: [
          Expanded(
            child: CustomPriceField(
              controller: minPrice,
              label: "Min",
            ),
          ),
          Expanded(
            child: CustomPriceField(
              controller: maxPrice,
              label: "Max",
            ),
          ),
        ],
      ),
    );
  }
}
