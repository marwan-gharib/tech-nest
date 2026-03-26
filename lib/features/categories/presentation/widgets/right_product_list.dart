import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/core/widgets/custom_snack_bar.dart';
import 'package:tech_nest/core/widgets/product_card.dart';
import 'package:tech_nest/features/categories/presentation/cubits/category_products_cubit/category_products_cubit.dart';
import 'package:tech_nest/features/categories/presentation/widgets/loading_more_indicator.dart';
import 'package:tech_nest/features/categories/presentation/widgets/product_skeleton_list.dart';

class RightProductList extends StatelessWidget {
  final ScrollController scrollController;

  const RightProductList({required this.scrollController, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CategoryProductsCubit, CategoryProductsState>(
      listener: (context, state) {
        if (state.errMessage != null) {
          CustomSnackBar.show(context, message: state.errMessage!);
        }
      },
      builder: (context, state) {
        if (state.products != null) {
          final products = state.products!;
          return ListView.builder(
            controller: scrollController,
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: products.length + (state.isLoadingMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == products.length) {
                return const LoadingMoreIndicator();
              }
              return ProductCard(product: products[index]);
            },
          );
        }
        return const ProductSkeletonList();
      },
    );
  }
}
