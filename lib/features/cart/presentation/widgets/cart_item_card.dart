import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tech_nest/core/constants/endpoints.dart';
import 'package:tech_nest/core/entities/product_entity.dart';

class CartItemCard extends StatelessWidget {
  final Product product;

  const CartItemCard({required this.product, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: [
          CachedNetworkImage(imageUrl: Endpoints.baseUrl + product.imgUrl),
        ],
      ),
    );
  }
}
