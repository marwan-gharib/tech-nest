import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/core/utils/extensions/localization_extension.dart';
import 'package:tech_nest/core/widgets/product_card.dart';
import 'package:tech_nest/core/widgets/remote_data_failure_view.dart';
import 'package:tech_nest/core/widgets/skeleton_card.dart';
import 'package:tech_nest/features/products/presentation/cubits/fetch_products_cubit/fetch_products_cubit.dart';

class ProductsGrid extends StatelessWidget {
  const ProductsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FetchProductsCubit, FetchProductsState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        switch (state) {
          case FetchProductsInitial():
          case FetchProductsLoading():
            return SliverGrid.builder(
              itemCount: 6,
              gridDelegate: _gridDelegate,
              itemBuilder: (context, index) => const SkeletonCard(),
            );
          case FetchProductsNoConnection():
            return SliverToBoxAdapter(
              child: RemoteDataFailureView(
                isNoConnection: true,
                onRetry: () =>
                    context.read<FetchProductsCubit>().initialFetching(),
              ),
            );
          case FetchProductsError(:final message):
            return SliverToBoxAdapter(
              child: RemoteDataFailureView(
                isNoConnection: false,
                detailMessage: message,
                onRetry: () =>
                    context.read<FetchProductsCubit>().initialFetching(),
              ),
            );
          case FetchProductsLoaded(
            :final products,
            :final isLoadingMore,
            :final loadMoreErrorMessage,
            :final loadMoreErrorIsNetwork,
          ):
            return SliverMainAxisGroup(
              slivers: [
                SliverGrid.builder(
                  itemCount: products.length,
                  gridDelegate: _gridDelegate,
                  itemBuilder: (context, index) {
                    return ProductCard(product: products[index]);
                  },
                ),
                if (loadMoreErrorMessage != null)
                  SliverToBoxAdapter(
                    child: RemoteDataFailureView(
                      isNoConnection: loadMoreErrorIsNetwork,
                      titleOverride: context.l10n.errorCouldNotLoadMore,
                      detailMessage: loadMoreErrorMessage,
                      compact: true,
                      onRetry: () =>
                          context.read<FetchProductsCubit>().fetchMore(),
                    ),
                  ),
                if (isLoadingMore)
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
