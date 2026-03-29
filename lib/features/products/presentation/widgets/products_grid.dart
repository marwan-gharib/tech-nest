import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/core/widgets/product_card.dart';
import 'package:tech_nest/core/widgets/skeleton_card.dart';
import 'package:tech_nest/core/widgets/remote_data_failure_view.dart';
import 'package:tech_nest/features/products/presentation/cubits/fetch_products_cubit/fetch_products_cubit.dart';

class ProductsGrid extends StatelessWidget {
  const ProductsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FetchProductsCubit, FetchProductsState>(
      builder: (context, state) {
        if (state.isLoading) {
          return SliverGrid.builder(
            itemCount: 6,
            gridDelegate: _gridDelegate,
            itemBuilder: (context, index) => const SkeletonCard(),
          );
        } else if (state.failure != null) {
          return SliverToBoxAdapter(
            child: RemoteDataFailureView(
              failure: state.failure!,
              onRetry: () =>
                  context.read<FetchProductsCubit>().initialFetching(),
            ),
          );
        } else {
          return SliverMainAxisGroup(
            slivers: [
              SliverGrid.builder(
                itemCount: state.products.length,
                gridDelegate: _gridDelegate,
                itemBuilder: (context, index) {
                  return ProductCard(product: state.products[index]);
                },
              ),
              if (state.isLoadingMore)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ),
            ],
          );
        }
      },
    );
  }

  SliverGridDelegate get _gridDelegate =>
      const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.85,
        crossAxisSpacing: AppSpacing.md,
        mainAxisSpacing: AppSpacing.md,
      );
}
