import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tech_nest/core/animations/skeleton_shimmer.dart';
import 'package:tech_nest/core/constants/endpoints.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/features/orders/domain/entities/order_item_entity.dart';
import 'package:tech_nest/i18n/strings.g.dart';

class OrderDetailsItemCard extends StatelessWidget {
  final OrderItemEntity item;

  const OrderDetailsItemCard({required this.item, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: theme.dividerColor.withValues(alpha: 0.1)),
      ),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: CachedNetworkImage(
            height: 50,
            width: 50,
            filterQuality: FilterQuality.high,
            fit: BoxFit.cover,
            memCacheHeight: 300,
            memCacheWidth: 300,
            imageUrl: "${Endpoints.baseUrl}${item.imageUrl}",
            placeholder: (context, url) => const SkeletonShimmer(
              width: 50,
              height: 50,
            ),
            errorWidget: (context, url, error) => Container(
              color: theme.colorScheme.surfaceContainerHighest,
              child: Icon(
                Icons.broken_image_outlined,
                color: theme.colorScheme.outline,
              ),
            ),
          ),
        ),
        title: Text(item.name),
        subtitle: Text('${context.t.cart.items}: ${item.quantity}'),
        trailing: Text(
          '\$${item.price.toStringAsFixed(2)}',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
