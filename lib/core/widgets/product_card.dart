import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:tech_nest/core/constants/assets.dart';
import 'package:tech_nest/core/constants/endpoints.dart';
import 'package:tech_nest/features/cart/presentation/cubits/cart/cart_cubit.dart';
import 'package:tech_nest/core/domain/entities/product_entity.dart';
import 'package:tech_nest/core/routing/routes.dart';
import 'package:tech_nest/core/theme/app_radius.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/core/widgets/custom_snack_bar.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({required this.product, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        height: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                    final currentLocation = GoRouterState.of(context).uri.path;
                    context.push(
                      '$currentLocation/${Routes.productDetailsScreen}/${product.id}',
                    );
                  },
                child: ClipRRect(
                  borderRadius: AppRadius.cardLg,
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    memCacheHeight: 300,
                    memCacheWidth: 300,
                    imageUrl: "${Endpoints.baseUrl}${product.imgUrl}",
                    placeholder: (context, url) => SpinKitWaveSpinner(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    errorWidget: (context, url, error) => Image.asset(
                      Assets.brokenImage,
                      fit: BoxFit.fill,
                      color: Theme.of(context).shadowColor,
                    ),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: '${product.price} ',
                              style: Theme.of(context).textTheme.labelMedium!
                                  .copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                            ),
                            TextSpan(
                              text: '\$',
                              style: Theme.of(context).textTheme.labelMedium!
                                  .copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.tertiary,
                                  ),
                            ),
                          ],
                        ),
                        style: Theme.of(context).textTheme.labelMedium!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                BlocConsumer<CartCubit, CartState>(
                  builder: _builder,
                  listener: _listener,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _listener(BuildContext context, CartState state) {
    if (state is CartFailed) {
      customSnackBar(context, message: state.message);
    }
  }

  Widget _builder(BuildContext context, CartState state) {
    return IconButton(
      onPressed: product.stock > 0
          ? () async => await context.read<CartCubit>().add(
              productId: product.id,
              quantity: 1,
            )
          : null,
      icon: Icon(
        Icons.add_shopping_cart_outlined,
        size: 20,
        color: product.stock > 0
            ? Theme.of(context).colorScheme.tertiaryFixed
            : Theme.of(context).colorScheme.outline,
      ),
    );
  }
}
