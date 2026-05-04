import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:tech_nest/core/animations/scale_tap.dart';
import 'package:tech_nest/core/animations/skeleton_shimmer.dart';
import 'package:tech_nest/core/constants/endpoints.dart';
import 'package:tech_nest/core/routing/routes.dart';
import 'package:tech_nest/core/theme/app_radius.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/core/utils/extensions/context_extensions.dart';
import 'package:tech_nest/core/widgets/build_price.dart';
import 'package:tech_nest/features/products/domain/entities/product_entity.dart';

class ProductCard extends StatelessWidget {
  final ProductEntity product;
  final VoidCallback? onAddToCart;

  static const double _cardHeight = 200.0;

  const ProductCard({required this.product, this.onAddToCart, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _cardHeight,
      decoration: BoxDecoration(
        color: context.colors.card,
        borderRadius: AppRadius.cardLg,
        boxShadow: [
          BoxShadow(
            color: context.colors.textPrimary.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ScaleTap(
              onTap: () => _onCardTap(context),
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppRadius.lg),
                ),
                child: Hero(
                  tag: 'product-${product.id}',
                  child: CachedNetworkImage(
                    filterQuality: FilterQuality.high,
                    fit: BoxFit.cover,
                    memCacheHeight: 300,
                    memCacheWidth: 300,
                    imageUrl: "${Endpoints.baseUrl}/${product.imgUrl}",
                    placeholder: (context, url) => const SkeletonShimmer(
                      width: double.infinity,
                      height: double.infinity,
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
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        product.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.labelLarge.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      BuildPrice(price: product.price, size: 14),
                    ],
                  ),
                ),
                _addToCartButton(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onCardTap(BuildContext context) {
    final currentLocation = GoRouterState.of(context).uri.path;
    final String routeName = currentLocation.contains(RoutePaths.home)
        ? RouteNames.homeProductDetails
        : RouteNames.categoryProductDetails;

    context.pushNamed(routeName, extra: product);
  }

  Widget _addToCartButton(BuildContext context) {
    return ScaleTap(
      onTap: product.stock > 0
          ? () {
              HapticFeedback.lightImpact();
              onAddToCart?.call();
            }
          : null,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.xs),
        decoration: BoxDecoration(
          color: product.stock > 0
              ? context.colorScheme.primary
              : context.colors.shimmerBase,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.add_rounded,
          size: 18,
          color: product.stock > 0
              ? context.colorScheme.onPrimary
              : context.colors.textSecondary,
        ),
      ),
    );
  }
}
