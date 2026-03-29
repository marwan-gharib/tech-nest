import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';

import 'package:tech_nest/core/constants/endpoints.dart';
import 'package:tech_nest/features/cart/presentation/cubits/cart/cart_cubit.dart';
import 'package:tech_nest/core/domain/entities/product_entity.dart';
import 'package:tech_nest/core/routing/routes.dart';
import 'package:tech_nest/core/theme/app_radius.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/core/widgets/build_price.dart';
import 'package:tech_nest/core/widgets/custom_snack_bar.dart';

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
                  fit: BoxFit.cover,
                  memCacheHeight: 400,
                  memCacheWidth: 400,
                  imageUrl: "${Endpoints.baseUrl}${product.imgUrl}",
                  placeholder: (context, url) => SpinKitWaveSpinner(
                    color: colorScheme.primary,
                    size: 40,
                  ),
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
                      BuildPrice(
                        price: product.price,
                        size: 14,
                      ),
                    ],
                  ),
                ),
                BlocConsumer<CartCubit, CartState>(
                  listenWhen: (previous, current) =>
                      current is CartLoaded &&
                      current.mutationErrorMessage != null &&
                      (previous is! CartLoaded ||
                          previous.mutationErrorMessage !=
                              current.mutationErrorMessage),
                  builder: _builder,
                  listener: _listener,
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
      '$currentLocation/${Routes.productDetailsScreen}/${product.id}',
    );
  }

  void _listener(BuildContext context, CartState state) {
    if (state is CartLoaded && state.mutationErrorMessage != null) {
      CustomSnackBar.show(context, message: state.mutationErrorMessage!);
      context.read<CartCubit>().clearMutationError();
    }
  }

  Widget _builder(BuildContext context, CartState state) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (state is CartLoading) {
      return const SizedBox(
        width: 40,
        height: 40,
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.xs),
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    if (state is CartLoaded && state.isMutating) {
      return const SizedBox(
        width: 40,
        height: 40,
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.xs),
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

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
