import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_nest/core/animations/skeleton_shimmer.dart';
import 'package:tech_nest/core/constants/endpoints.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/core/utils/extensions/context_extensions.dart';
import 'package:tech_nest/core/widgets/build_price.dart';
import 'package:tech_nest/features/cart/domain/entities/cart_item_entity.dart';
import 'package:tech_nest/features/cart/presentation/cubits/cart/cart_cubit.dart';
import 'package:tech_nest/features/cart/presentation/cubits/delete_cart_item_cubit/delete_cart_item_cubit.dart';
import 'package:tech_nest/features/cart/presentation/cubits/update_item_quantity_cubit/update_item_quantity_cubit.dart';
import 'package:tech_nest/features/cart/presentation/widgets/change_cart_item_count.dart';
import 'package:tech_nest/features/cart/presentation/widgets/remove_cart_item_button.dart';
import 'package:tech_nest/app/service_locator.dart';

class CartItemCard extends StatefulWidget {
  final CartItem cartItem;

  const CartItemCard({required this.cartItem, super.key});

  @override
  State<CartItemCard> createState() => _CartItemCardState();
}

class _CartItemCardState extends State<CartItemCard>
    with SingleTickerProviderStateMixin {
  static const double _cardHeight = 100.0;
  static const double _imageWidth = 125.0;
  static const double _borderRadius = 10.0;
  static const double _priceSize = 16.0;

  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      value: 1.0,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleDeleteSuccess() async {
    await _controller.reverse();
    if (mounted) {
      context.read<CartCubit>().removeItemLocally(id: widget.cartItem.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: _controller,
      child: Container(
        color: context.colors.background,
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
                filterQuality: FilterQuality.high,
                imageUrl: Endpoints.baseUrl + widget.cartItem.product.imgUrl,
                memCacheHeight: 300,
                memCacheWidth: 300,
                height: _cardHeight,
                width: _imageWidth,
                fit: BoxFit.fill,
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
                          widget.cartItem.product.name,
                          style: context.labelMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      BlocProvider(
                        create: (context) => sl<DeleteCartItemCubit>(),
                        child: RemoveCartItemButton(
                          cartId: widget.cartItem.id,
                          onDeleteSuccess: _handleDeleteSuccess,
                        ),
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
                          price: widget.cartItem.product.price,
                          size: _priceSize,
                        ),
                        BlocProvider(
                          create: (context) => sl<UpdateItemQuantityCubit>(),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: ChangeCartItemCount(
                              cartId: widget.cartItem.id,
                              initialCount: widget.cartItem.quantity,
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
      ),
    );
  }
}
