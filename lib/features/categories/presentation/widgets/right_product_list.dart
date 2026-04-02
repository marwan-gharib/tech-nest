import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/core/shared/utils/extensions/localization_extension.dart';
import 'package:tech_nest/core/shared/widgets/product_card.dart';
import 'package:tech_nest/core/shared/widgets/remote_data_failure_view.dart';
import 'package:tech_nest/core/shared/widgets/skeleton_card.dart';
import 'package:tech_nest/features/categories/presentation/cubits/category_products_cubit/category_products_cubit.dart';
import 'package:tech_nest/features/categories/presentation/widgets/loading_more_indicator.dart';

class RightProductList extends StatelessWidget {
  final ScrollController scrollController;

  const RightProductList({required this.scrollController, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryProductsCubit, CategoryProductsState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        if (state is CategoryProductsInitial ||
            state is CategoryProductsLoading) {
          return ListView.builder(
            itemCount: 4,
            padding: const EdgeInsets.all(AppSpacing.sm),
            itemBuilder: (context, index) => const Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.md),
              child: SkeletonCard(),
            ),
          );
        }

        if (state is CategoryProductsError) {
          return RemoteDataFailureView(
            failure: state.failure,
            onRetry: () => context
                .read<CategoryProductsCubit>()
                .retryInitialCategoryProducts(),
          );
        }

        if (state is CategoryProductsLoaded) {
          return ListView.builder(
            controller: scrollController,
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount:
                state.products.length +
                (state.loadMoreFailure != null ? 1 : 0) +
                (state.isLoadingMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index < state.products.length) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: ProductCard(product: state.products[index]),
                );
              }
              final afterProducts = index - state.products.length;
              if (state.loadMoreFailure != null && afterProducts == 0) {
                return RemoteDataFailureView(
                  failure: state.loadMoreFailure!,
                  titleOverride: context.l10n.errorCouldNotLoadMore,
                  compact: true,
                  onRetry: () => context
                      .read<CategoryProductsCubit>()
                      .fetchMoreCategoryProducts(),
                );
              }
              if (state.isLoadingMore) {
                return const LoadingMoreIndicator();
              }
              return const SizedBox.shrink();
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
