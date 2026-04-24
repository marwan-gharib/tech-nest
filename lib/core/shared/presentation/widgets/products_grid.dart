import 'package:flutter/material.dart';
import 'package:tech_nest/features/products/domain/entities/product_entity.dart';
import 'package:tech_nest/core/shared/presentation/widgets/no_results_found_view.dart';
import 'package:tech_nest/core/shared/presentation/widgets/product_card.dart';
import 'package:tech_nest/core/shared/presentation/widgets/remote_data_failure_view.dart';
import 'package:tech_nest/core/shared/presentation/widgets/skeleton_card.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/core/error/failures/failure.dart';

class ProductsGrid extends StatelessWidget {
  final List<ProductEntity> products;
  final bool isLoading;
  final bool isLoadingMore;
  final Failure? error;
  final Failure? loadMoreError;
  final VoidCallback onRetry;
  final VoidCallback onFetchMore;
  final VoidCallback? onAddToCart;
  final Function(ProductEntity)? onProductAddToCart;
  final bool isSearchApplied;
  final bool isFilterApplied;
  final String noResultsTitle;
  final String noResultsMessage;

  const ProductsGrid({
    required this.products,
    required this.isLoading,
    required this.onRetry,
    required this.onFetchMore,
    required this.noResultsTitle,
    required this.noResultsMessage,
    this.isLoadingMore = false,
    this.error,
    this.loadMoreError,
    this.onAddToCart,
    this.onProductAddToCart,
    this.isSearchApplied = false,
    this.isFilterApplied = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return SliverGrid.builder(
        itemCount: 6,
        gridDelegate: _gridDelegate,
        itemBuilder: (context, index) => const SkeletonCard(),
      );
    }

    if (error != null) {
      return SliverFillRemaining(
        child: RemoteDataFailureView(
          failure: error!,
          onRetry: onRetry,
        ),
      );
    }

    if ((isSearchApplied || isFilterApplied) && products.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: NoResultsFoundView(
          title: noResultsTitle,
          message: noResultsMessage,
          icon: isSearchApplied
              ? Icons.search_off_rounded
              : Icons.filter_alt_off_rounded,
        ),
      );
    }

    return SliverMainAxisGroup(
      slivers: [
        SliverGrid.builder(
          itemCount: products.length,
          gridDelegate: _gridDelegate,
          itemBuilder: (context, index) {
            final product = products[index];
            return ProductCard(
              product: product,
              onAddToCart: () => onProductAddToCart?.call(product),
            );
          },
        ),
        if (loadMoreError != null)
          SliverToBoxAdapter(
            child: RemoteDataFailureView(
              failure: loadMoreError!,
              compact: true,
              onRetry: onFetchMore,
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

  SliverGridDelegate get _gridDelegate =>
      const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.85,
        crossAxisSpacing: AppSpacing.md,
        mainAxisSpacing: AppSpacing.md,
      );
}
