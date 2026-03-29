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

final class CategoryProductsNoConnection extends CategoryProductsState {
  const CategoryProductsNoConnection();
}

final class CategoryProductsError extends CategoryProductsState {
  final String message;

  const CategoryProductsError(this.message);

  @override
  List<Object?> get props => [message];
}

final class CategoryProductsLoaded extends CategoryProductsState {
  final List<ProductEntity> products;
  final bool isLoadingMore;
  final bool hasReachedMax;
  final String? loadMoreErrorMessage;
  final bool loadMoreErrorIsNetwork;

  const CategoryProductsLoaded({
    required this.products,
    this.isLoadingMore = false,
    this.hasReachedMax = false,
    this.loadMoreErrorMessage,
    this.loadMoreErrorIsNetwork = false,
  });

  CategoryProductsLoaded copyWith({
    List<ProductEntity>? products,
    bool? isLoadingMore,
    bool? hasReachedMax,
    String? loadMoreErrorMessage,
    bool? loadMoreErrorIsNetwork,
    bool clearLoadMoreError = false,
  }) {
    return CategoryProductsLoaded(
      products: products ?? this.products,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      loadMoreErrorMessage: clearLoadMoreError
          ? null
          : (loadMoreErrorMessage ?? this.loadMoreErrorMessage),
      loadMoreErrorIsNetwork: clearLoadMoreError
          ? false
          : (loadMoreErrorIsNetwork ?? this.loadMoreErrorIsNetwork),
    );
  }

  @override
  List<Object?> get props => [
    products,
    isLoadingMore,
    hasReachedMax,
    loadMoreErrorMessage,
    loadMoreErrorIsNetwork,
  ];
}
