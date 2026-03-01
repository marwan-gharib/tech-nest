import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_nest/core/params/products_params.dart';
import 'package:tech_nest/core/widgets/product_card.dart';
import 'package:tech_nest/features/products/presentation/cubits/fetch_products_cubit/fetch_products_cubit.dart';

class ProductsGrid extends StatelessWidget {
  final ProductsParams params;

  const ProductsGrid({required this.params, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FetchProductsCubit, FetchProductsState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const SliverToBoxAdapter(
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (state.errMessage != null) {
          return SliverToBoxAdapter(
            child: Center(
              child: Column(
                spacing: 20,
                children: [
                  const SizedBox(height: 30),
                  Text(
                    state.errMessage!,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge!.copyWith(wordSpacing: 2),
                    textAlign: TextAlign.center,
                  ),
                  IconButton(
                    onPressed: () => context
                        .read<FetchProductsCubit>()
                        .initialFetching(params: params),
                    icon: const Icon(Icons.refresh, size: 100),
                  ),
                ],
              ),
            ),
          );
        } else {
          return SliverMainAxisGroup(
            slivers: [
              SliverGrid.builder(
                itemCount: state.products.length,
                gridDelegate: _sliverGridDelegateWithFixedCrossAxisCount,
                itemBuilder: (context, index) {
                  final product = state.products[index];
                  return ProductCard(product: product);
                },
              ),
              if (state.isLoadingMore)
                SliverToBoxAdapter(
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 30),
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(),
                    ),
                  ),
                ),
            ],
          );
        }
      },
    );
  }

  SliverGridDelegateWithFixedCrossAxisCount
  get _sliverGridDelegateWithFixedCrossAxisCount =>
      const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.9,
        crossAxisSpacing: 18,
        mainAxisSpacing: 14,
      );
}
