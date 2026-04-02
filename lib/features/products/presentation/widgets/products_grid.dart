import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/core/shared/utils/extensions/localization_extension.dart';
import 'package:tech_nest/core/shared/widgets/product_card.dart';
import 'package:tech_nest/core/shared/widgets/remote_data_failure_view.dart';
import 'package:tech_nest/core/shared/widgets/skeleton_card.dart';
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

          case FetchProductsError():
            return SliverFillRemaining(
              child: RemoteDataFailureView(
                failure: state.failure,
                onRetry: () =>
                    context.read<FetchProductsCubit>().initialFetching(),
              ),
            );

          case FetchProductsLoaded():
            if (state.isSearchApplied && state.products.isEmpty) {
              return SliverFillRemaining(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Text(
                      "No Products Found",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ),
              );
            }
            return SliverMainAxisGroup(
              slivers: [
                SliverGrid.builder(
                  itemCount: state.products.length,
                  gridDelegate: _gridDelegate,
                  itemBuilder: (context, index) {
                    return ProductCard(product: state.products[index]);
                  },
                ),
                if (state.loadMoreFailure != null)
                  SliverToBoxAdapter(
                    child: RemoteDataFailureView(
                      failure: state.loadMoreFailure!,
                      titleOverride: context.l10n.errorCouldNotLoadMore,
                      compact: true,
                      onRetry: () =>
                          context.read<FetchProductsCubit>().fetchMore(),
                    ),
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
