import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tech_nest/core/constants/endpoints.dart';
import 'package:tech_nest/core/utils/extensions/context_extensions.dart';
import 'package:tech_nest/core/utils/logger.dart';
import 'package:tech_nest/features/products/domain/entities/product_entity.dart';

class ProductHeroImage extends StatelessWidget {
  final ProductEntity product;
  const ProductHeroImage({required this.product, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.sizeOf(context).height * 0.45,
      child: Hero(
        tag: 'product-${product.id}',
        child: CachedNetworkImage(
          filterQuality: FilterQuality.high,
          memCacheHeight: 300,
          memCacheWidth: 300,
          imageUrl: '${Endpoints.baseUrl}/${product.imgUrl}',
          fit: BoxFit.cover,
          placeholder: (context, url) =>
              SpinKitWaveSpinner(color: context.colorScheme.primary, size: 40),
          errorWidget: (context, url, error) {
            AppLogger.error(
              'Failed to load product image: $error \n url: $url',
            );
            return Container(
              color: context.colors.shimmerBase,
              child: Icon(
                Icons.broken_image_outlined,
                color: context.colors.textSecondary,
              ),
            );
          },
        ),
      ),
    );
  }
}
