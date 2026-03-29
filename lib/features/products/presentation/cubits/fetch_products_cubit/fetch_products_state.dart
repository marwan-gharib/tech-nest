part of 'fetch_products_cubit.dart';

sealed class FetchProductsState extends Equatable {
  const FetchProductsState();

  @override
  List<Object?> get props => [];
}

final class FetchProductsInitial extends FetchProductsState {
  const FetchProductsInitial();
}

final class FetchProductsLoading extends FetchProductsState {
  const FetchProductsLoading();
}

final class FetchProductsError extends FetchProductsState {
  final Failure failure;

  const FetchProductsError(this.failure);

  @override
  List<Object?> get props => [failure];
}

final class FetchProductsLoaded extends FetchProductsState {
  final List<ProductEntity> products;
  final bool isLoadingMore;
  final bool hasReachedMax;
  final Failure? loadMoreFailure;

  const FetchProductsLoaded({
    required this.products,
    this.isLoadingMore = false,
    this.hasReachedMax = false,
    this.loadMoreFailure,
  });

  FetchProductsLoaded copyWith({
    List<ProductEntity>? products,
    bool? isLoadingMore,
    bool? hasReachedMax,
    Failure? loadMoreFailure,
    bool clearLoadMoreError = false,
  }) {
    return FetchProductsLoaded(
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
