import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:tech_nest/core/constants/endpoints.dart';
import 'package:tech_nest/core/routing/routes.dart';
import 'package:tech_nest/core/shared/cubits/cart/cart_cubit.dart';
import 'package:tech_nest/core/shared/domain/entities/product_entity.dart';
import 'package:tech_nest/core/shared/widgets/build_price.dart';
import 'package:tech_nest/core/shared/widgets/custom_snack_bar.dart';
import 'package:tech_nest/core/theme/app_radius.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';

class ProductCard extends StatelessWidget {
  final ProductEntity product;

  static const double _cardHeight = 200.0;

  const ProductCard({required this.product, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      height: _cardHeight,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: AppRadius.cardLg,
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => _onCardTap(context),
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppRadius.lg),
                ),
                child: CachedNetworkImage(
                  filterQuality: FilterQuality.high,
                  fit: BoxFit.cover,
                  memCacheHeight: 300,
                  memCacheWidth: 300,
                  imageUrl: "${Endpoints.baseUrl}${product.imgUrl}",
                  placeholder: (context, url) =>
                      SpinKitWaveSpinner(color: colorScheme.primary, size: 40),
                  errorWidget: (context, url, error) => Container(
                    color: colorScheme.surfaceContainerHighest,
                    child: Icon(
                      Icons.broken_image_outlined,
                      color: colorScheme.outline,
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
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      BuildPrice(price: product.price, size: 14),
                    ],
                  ),
                ),
                BlocListener<CartCubit, CartState>(
                  listenWhen: (previous, current) =>
                      current is CartLoaded &&
                      current.mutationFailure != null &&
                      (previous is! CartLoaded ||
                          previous.mutationFailure != current.mutationFailure),
                  listener: _listener,
                  child: _addToCartButton(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onCardTap(BuildContext context) {
    final currentLocation = GoRouterState.of(context).uri.path;
    // Ensure we don't double up on locations if already in details
    if (currentLocation.contains(Routes.productDetailsScreen)) return;

    context.push(
      '$currentLocation/${Routes.productDetailsScreen}',
      extra: product,
    );
  }

  void _listener(BuildContext context, CartState state) {
    if (state is CartLoaded && state.mutationFailure != null) {
      CustomSnackBar.showError(context, failure: state.mutationFailure!);
      context.read<CartCubit>().clearMutationError();
    }
  }

  Widget _addToCartButton(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return IconButton(
      onPressed: product.stock > 0
          ? () => context.read<CartCubit>().add(
              productId: product.id,
              quantity: 1,
            )
          : null,
      icon: Container(
        padding: const EdgeInsets.all(AppSpacing.xs),
        decoration: BoxDecoration(
          color: product.stock > 0
              ? colorScheme.primaryContainer
              : colorScheme.surfaceContainerHighest,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.add_rounded,
          size: 18,
          color: product.stock > 0
              ? colorScheme.onPrimaryContainer
              : colorScheme.outline,
        ),
      ),
    );
  }
}
