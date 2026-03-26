import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tech_nest/core/domain/entities/product_entity.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/core/widgets/product_card.dart';

class ProductSkeletonList extends StatelessWidget {
  const ProductSkeletonList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Skeletonizer(
          child: ProductCard(product: ProductEntity.empty()),
        );
      },
    );
  }
}
