import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:tech_nest/core/constants/assets.dart';
import 'package:tech_nest/core/constants/endpoints.dart';
import 'package:tech_nest/core/entities/product_entity.dart';
import 'package:tech_nest/core/router/routers.dart';

class ProductCard extends StatelessWidget {
  final ProductEntity product;

  const ProductCard({required this.product, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          context.pushNamed(Routers.productDetailsScreen, extra: product),
      child: Card(
        clipBehavior: Clip.hardEdge,
        child: SizedBox(
          height: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(12),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 10),
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
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.shopping_cart,
                      color: Theme.of(context).colorScheme.tertiaryFixed,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
