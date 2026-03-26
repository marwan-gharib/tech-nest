import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tech_nest/core/constants/endpoints.dart';
import 'package:tech_nest/core/domain/entities/product_entity.dart';

class ProductHeroImage extends StatelessWidget {
  final ProductEntity product;
  const ProductHeroImage({required this.product, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.sizeOf(context).height * 0.45,
      child: CachedNetworkImage(
        imageUrl: Endpoints.baseUrl + product.imgUrl,
        fit: BoxFit.cover,
      ),
    );
  }
}
