import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/core/utils/extensions/localization_extension.dart';
import 'package:tech_nest/core/widgets/product_card.dart';
import 'package:tech_nest/core/widgets/remote_data_failure_view.dart';
import 'package:tech_nest/features/categories/presentation/cubits/category_products_cubit/category_products_cubit.dart';
import 'package:tech_nest/features/categories/presentation/widgets/loading_more_indicator.dart';
import 'package:tech_nest/features/categories/presentation/widgets/product_skeleton_list.dart';

class RightProductList extends StatelessWidget {
  final ScrollController scrollController;

  const RightProductList({required this.scrollController, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryProductsCubit, CategoryProductsState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        return switch (state) {
          CategoryProductsInitial() ||
          CategoryProductsLoading() =>
            const ProductSkeletonList(),
          CategoryProductsNoConnection() => RemoteDataFailureView(
            isNoConnection: true,
            onRetry: () =>
                context.read<CategoryProductsCubit>().retryInitialCategoryProducts(),
          ),
          CategoryProductsError(:final message) => RemoteDataFailureView(
            isNoConnection: false,
            detailMessage: message,
            onRetry: () =>
                context.read<CategoryProductsCubit>().retryInitialCategoryProducts(),
          ),
          CategoryProductsLoaded(
            :final products,
            :final isLoadingMore,
            :final loadMoreErrorMessage,
            :final loadMoreErrorIsNetwork,
          ) =>
            ListView.builder(
              controller: scrollController,
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: products.length +
                  (loadMoreErrorMessage != null ? 1 : 0) +
                  (isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < products.length) {
                  return ProductCard(product: products[index]);
                }
                final afterProducts = index - products.length;
                if (loadMoreErrorMessage != null && afterProducts == 0) {
                  return RemoteDataFailureView(
                    isNoConnection: loadMoreErrorIsNetwork,
                    titleOverride: context.l10n.errorCouldNotLoadMore,
                    detailMessage: loadMoreErrorMessage,
                    compact: true,
                    onRetry: () =>
                        context.read<CategoryProductsCubit>().fetchMoreCategoryProducts(),
                  );
                }
                if (isLoadingMore) {
                  return const LoadingMoreIndicator();
                }
                return const SizedBox.shrink();
              },
            ),
        };
      },
    );
  }
}
