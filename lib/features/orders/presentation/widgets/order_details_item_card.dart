import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tech_nest/core/animations/skeleton_shimmer.dart';
import 'package:tech_nest/core/constants/endpoints.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/core/utils/extensions/context_extensions.dart';
import 'package:tech_nest/features/orders/domain/entities/order_item_entity.dart';
import 'package:tech_nest/i18n/strings.g.dart';

class OrderDetailsItemCard extends StatelessWidget {
  final OrderItemEntity item;

  const OrderDetailsItemCard({required this.item, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      elevation: 0,
      color: context.colors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: context.colors.border.withValues(alpha: 0.5)),
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
              color: context.colors.shimmerBase,
              child: Icon(
                Icons.broken_image_outlined,
                color: context.colors.textSecondary,
              ),
            ),
          ),
        ),
        title: Text(
          item.name,
          style: context.bodyLarge.copyWith(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          '${context.t.cart.items}: ${item.quantity}',
          style: context.bodyMedium.copyWith(color: context.colors.textSecondary),
        ),
        trailing: Text(
          '\$${item.price.toStringAsFixed(2)}',
          style: context.titleMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: context.colorScheme.primary,
          ),
        ),
      ),
    );
  }
}

