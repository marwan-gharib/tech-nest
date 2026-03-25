import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_nest/core/constants/endpoints.dart';
import 'package:tech_nest/core/di/service_locator.dart';
import 'package:tech_nest/core/widgets/build_price.dart';
import 'package:tech_nest/features/cart/domain/entities/cart_item.dart';
import 'package:tech_nest/features/cart/presentation/cubits/delete_cart_item_cubit/delete_cart_item_cubit.dart';
import 'package:tech_nest/features/cart/presentation/cubits/update_item_quantity_cubit/update_item_quantity_cubit.dart';
import 'package:tech_nest/features/cart/presentation/widgets/change_cart_item_count.dart';
import 'package:tech_nest/features/cart/presentation/widgets/remove_cart_item_button.dart';

class CartItemCard extends StatelessWidget {
  final CartItem cartItem;

  const CartItemCard({required this.cartItem, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      constraints: const BoxConstraints(maxHeight: 100, minHeight: 100),
      margin: const EdgeInsets.only(bottom: 20),
      child: Row(
        spacing: 5,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadiusGeometry.circular(10),
            child: CachedNetworkImage(
              imageUrl: Endpoints.baseUrl + cartItem.product.imgUrl,
              memCacheHeight: 300,
              memCacheWidth: 300,
              height: 100,
              width: 125,
              fit: BoxFit.fill,
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  spacing: 20,
                  children: [
                    Expanded(
                      child: Text(
                        "${cartItem.product.name}ascknlad cakldcnlkdazdc ascdlk",
                        style: Theme.of(context).textTheme.labelMedium,
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
                const SizedBox(height: 10),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BuildPrice(price: cartItem.product.price, size: 16),
                      BlocProvider(
                        create: (context) => sl<UpdateItemQuantityCubit>(),
                        child: Align(
                          alignment: AlignmentGeometry.bottomCenter,
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
