part of 'category_products_cubit.dart';

sealed class CategoryProductsState extends Equatable {
  const CategoryProductsState();

  @override
  List<Object?> get props => [];
}

final class CategoryProductsInitial extends CategoryProductsState {
  const CategoryProductsInitial();
}

final class CategoryProductsLoading extends CategoryProductsState {
  const CategoryProductsLoading();
}

final class CategoryProductsError extends CategoryProductsState {
  final Failure failure;

  const CategoryProductsError(this.failure);

  @override
  List<Object?> get props => [failure];
}

final class CategoryProductsLoaded extends CategoryProductsState {
  final List<ProductEntity> products;
  final bool isLoadingMore;
  final bool hasReachedMax;
  final Failure? loadMoreFailure;

  const CategoryProductsLoaded({
    required this.products,
    this.isLoadingMore = false,
    this.hasReachedMax = false,
    this.loadMoreFailure,
  });

  CategoryProductsLoaded copyWith({
    List<ProductEntity>? products,
    bool? isLoadingMore,
    bool? hasReachedMax,
    Failure? loadMoreFailure,
    bool clearLoadMoreError = false,
  }) {
    return CategoryProductsLoaded(
      products: products ?? this.products,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      loadMoreFailure: clearLoadMoreError
          ? null
          : (loadMoreFailure ?? this.loadMoreFailure),
    );
  }

  @override
  List<Object?> get props => [
    products,
    isLoadingMore,
    hasReachedMax,
    loadMoreFailure,
  ];
}
