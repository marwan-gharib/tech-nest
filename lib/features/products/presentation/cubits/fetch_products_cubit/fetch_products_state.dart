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

final class FetchProductsNoConnection extends FetchProductsState {
  const FetchProductsNoConnection();
}

final class FetchProductsError extends FetchProductsState {
  final String message;

  const FetchProductsError(this.message);

  @override
  List<Object?> get props => [message];
}

final class FetchProductsLoaded extends FetchProductsState {
  final List<ProductEntity> products;
  final bool isLoadingMore;
  final bool hasReachedMax;
  final String? loadMoreErrorMessage;
  final bool loadMoreErrorIsNetwork;

  const FetchProductsLoaded({
    required this.products,
    this.isLoadingMore = false,
    this.hasReachedMax = false,
    this.loadMoreErrorMessage,
    this.loadMoreErrorIsNetwork = false,
  });

  FetchProductsLoaded copyWith({
    List<ProductEntity>? products,
    bool? isLoadingMore,
    bool? hasReachedMax,
    String? loadMoreErrorMessage,
    bool? loadMoreErrorIsNetwork,
    bool clearLoadMoreError = false,
  }) {
    return FetchProductsLoaded(
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
