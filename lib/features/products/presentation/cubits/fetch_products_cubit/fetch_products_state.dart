part of 'fetch_products_cubit.dart';

class FetchProductsState extends Equatable {
  final List<ProductEntity> products;
  final String? errMessage;
  final Failure? failure;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasReachedMax;
  final int page;

  const FetchProductsState({
    this.products = const [],
    this.errMessage,
    this.failure,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasReachedMax = false,
    this.page = 1,
  });

  FetchProductsState copyWith({
    List<ProductEntity>? products,
    String? errMessage,
    Failure? failure,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasReachedMax,
    int? page,
  }) {
    return FetchProductsState(
      products: products ?? this.products,
      errMessage: errMessage ?? this.errMessage,
      failure: failure ?? this.failure,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      page: page ?? this.page,
    );
  }

  @override
  List<Object?> get props => [
    products,
    errMessage,
    failure,
    isLoading,
    isLoadingMore,
    hasReachedMax,
    page,
  ];
}
