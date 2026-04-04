import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tech_nest/core/constants/endpoints.dart';
import 'package:tech_nest/core/di/service_locator.dart';
import 'package:tech_nest/core/shared/widgets/build_price.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/features/cart/domain/entities/cart_item_entity.dart';
import 'package:tech_nest/features/cart/presentation/cubits/delete_cart_item_cubit/delete_cart_item_cubit.dart';
import 'package:tech_nest/features/cart/presentation/cubits/update_item_quantity_cubit/update_item_quantity_cubit.dart';
import 'package:tech_nest/features/cart/presentation/widgets/change_cart_item_count.dart';
import 'package:tech_nest/features/cart/presentation/widgets/remove_cart_item_button.dart';

class CartItemCard extends StatelessWidget {
  final CartItem cartItem;

  static const double _cardHeight = 100.0;
  static const double _imageWidth = 125.0;
  static const double _borderRadius = 10.0;
  static const double _priceSize = 16.0;

  const CartItemCard({required this.cartItem, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      color: theme.scaffoldBackgroundColor,
      constraints: const BoxConstraints(
        maxHeight: _cardHeight,
        minHeight: _cardHeight,
      ),
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Row(
        spacing: AppSpacing.xs + 1,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(_borderRadius),
            child: CachedNetworkImage(
              imageUrl: Endpoints.baseUrl + cartItem.product.imgUrl,
              memCacheHeight: 300,
              memCacheWidth: 300,
              height: _cardHeight,
              width: _imageWidth,
              fit: BoxFit.fill,
              placeholder: (context, url) => SpinKitWaveSpinner(
                color: Theme.of(context).colorScheme.primary,
                size: 40,
              ),
              errorWidget: (context, url, error) => Container(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: Icon(
                  Icons.broken_image_outlined,
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  spacing: AppSpacing.md + 4,
                  children: [
                    Expanded(
                      child: Text(
                        cartItem.product.name,
                        style: theme.textTheme.labelMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    BlocProvider(
                      create: (context) => sl<DeleteCartItemCubit>(),
                      child: RemoveCartItemButton(cartId: cartItem.id),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm + 2),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BuildPrice(
                        price: cartItem.product.price,
                        size: _priceSize,
                      ),
                      BlocProvider(
                        create: (context) => sl<UpdateItemQuantityCubit>(),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: ChangeCartItemCount(
                            cartId: cartItem.id,
                            initialCount: cartItem.quantity,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
