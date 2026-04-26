import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_nest/features/products/presentation/widgets/shared/product_card.dart';
import 'package:tech_nest/core/widgets/remote_data_failure_view.dart';
import 'package:tech_nest/core/animations/animate_once_wrapper.dart';
import 'package:tech_nest/core/animations/fade_in_slide.dart';
import 'package:tech_nest/core/widgets/skeleton_card.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/features/categories/presentation/cubits/category_products_cubit/category_products_cubit.dart';
import 'package:tech_nest/core/widgets/loading_more_indicator.dart';
import 'package:tech_nest/features/cart/presentation/cubits/cart/cart_cubit.dart';
import 'package:tech_nest/i18n/strings.g.dart';

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
          return RepaintBoundary(
            child: ListView.builder(
              itemCount: 4,
              padding: const EdgeInsets.all(AppSpacing.sm),
              itemBuilder: (context, index) => FadeInSlide(
                duration: const Duration(milliseconds: 400),
                delay: Duration(milliseconds: index * 50),
                child: const Padding(
                  padding: EdgeInsets.only(bottom: AppSpacing.md),
                  child: SkeletonCard(),
                ),
              ),
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
          return RepaintBoundary(
            child: ListView.builder(
              controller: scrollController,
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: state.products.length +
                  (state.loadMoreFailure != null ? 1 : 0) +
                  (state.isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < state.products.length) {
                  final product = state.products[index];
                  return AnimateOnceWrapper(
                    namespace: 'right_product_list',
                    id: 'product_${product.id}',
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: ProductCard(
                        product: product,
                        onAddToCart: () {
                          context.read<CartCubit>().add(
                                productId: product.id,
                                quantity: 1,
                              );
                        },
                      ),
                    ),
                    animationBuilder: (context, child) => FadeInSlide(
                      duration: const Duration(milliseconds: 400),
                      delay: Duration(milliseconds: (index % 10) * 50),
                      child: child,
                    ),
                  );
                }
                final afterProducts = index - state.products.length;
                if (state.loadMoreFailure != null && afterProducts == 0) {
                  return RemoteDataFailureView(
                    failure: state.loadMoreFailure!,
                    titleOverride: context.t.errors.loadMoreFailed,
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
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
