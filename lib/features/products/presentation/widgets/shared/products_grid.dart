import 'package:flutter/material.dart';
import 'package:tech_nest/i18n/strings.g.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_nest/features/products/presentation/cubits/fetch_products_cubit/fetch_products_cubit.dart';
import 'package:tech_nest/core/widgets/no_results_found_view.dart';
import 'package:tech_nest/features/products/presentation/widgets/shared/product_card.dart';
import 'package:tech_nest/core/widgets/remote_data_failure_view.dart';
import 'package:tech_nest/core/widgets/skeleton_card.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/features/cart/presentation/cubits/cart/cart_cubit.dart';

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
            if ((state.isSearchApplied) && state.products.isEmpty) {
              return SliverFillRemaining(
                hasScrollBody: false,
                child: NoResultsFoundView(
                  title: context.t.errors.noResults,
                  message: context.t.errors.noResultsSearch,
                  icon: Icons.search_off_rounded,
                ),
              );
            }
            if ((state.isFilterApplied) && state.products.isEmpty) {
              return SliverFillRemaining(
                hasScrollBody: false,
                child: NoResultsFoundView(
                  title: context.t.errors.noResults,
                  message: context.t.errors.noResultsFilter,
                  icon: Icons.filter_alt_off_rounded,
                ),
              );
            }
            return SliverMainAxisGroup(
              slivers: [
                SliverGrid.builder(
                  itemCount: state.products.length,
                  gridDelegate: _gridDelegate,
                  itemBuilder: (context, index) {
                    final product = state.products[index];
                    return ProductCard(
                      product: product,
                      onAddToCart: () {
                        context.read<CartCubit>().add(
                              productId: product.id,
                              quantity: 1,
                            );
                      },
                    );
                  },
                ),
                if (state.loadMoreFailure != null)
                  SliverToBoxAdapter(
                    child: RemoteDataFailureView(
                      failure: state.loadMoreFailure!,
                      titleOverride: context.t.errors.loadMoreFailed,
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
