import 'package:flutter/material.dart';
import 'package:tech_nest/features/products/domain/entities/product_entity.dart';
import 'package:tech_nest/core/shared/presentation/widgets/build_price.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/features/products/presentation/widgets/custom_counter.dart';
import 'package:tech_nest/i18n/strings.g.dart';

class ProductInfoSection extends StatelessWidget {
  final ProductEntity product;
  final ValueChanged<int> onQuantityChanged;

  const ProductInfoSection({
    required this.product,
    required this.onQuantityChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final secondaryColor = theme.shadowColor.withValues(alpha: 0.6);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: AppSpacing.xs,
            children: [
              Text(
                product.name,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              Text(
                context.t.products.category(category: product.category.name),
                style: theme.textTheme.labelLarge?.copyWith(
                  color: secondaryColor,
                ),
              ),
              BuildPrice(price: product.price, isLabeled: true),
              Text(
                product.stock > 0
                    ? context.t.products.inStock(n: product.stock)
                    : context.t.products.outOfStock,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: product.stock > 0
                      ? theme.colorScheme.tertiary
                      : theme.colorScheme.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        CustomCounter(maxCount: product.stock, onChanged: onQuantityChanged),
      ],
    );
  }
}
