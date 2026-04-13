import 'package:flutter/material.dart';
import 'package:tech_nest/i18n/strings.g.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/features/cart/presentation/widgets/cart_details_widget.dart';

class OrderSummary extends StatelessWidget {
  const OrderSummary({super.key});

  static const double _summaryRadius = 12.0;
  static const double _titleSize = 18.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm - 2,
        vertical: AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(_summaryRadius),
          topRight: Radius.circular(_summaryRadius),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppSpacing.md - 2,
        children: [
          Text(
            context.t.cart.summary,
            style: theme.textTheme.labelLarge?.copyWith(fontSize: _titleSize),
          ),
          const CartDetailsWidget(),
        ],
      ),
    );
  }
}
