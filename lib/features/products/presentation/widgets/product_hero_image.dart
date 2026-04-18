import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tech_nest/core/constants/endpoints.dart';
import 'package:tech_nest/core/shared/domain/entities/product_entity.dart';

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
          imageUrl: Endpoints.baseUrl + product.imgUrl,
          fit: BoxFit.cover,
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
    );
  }
}
