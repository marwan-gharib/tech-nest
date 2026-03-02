part of 'fetch_products_cubit.dart';

class FetchProductsState extends Equatable {
  final List<Product> products;
  final String? errMessage;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasReachedMax;
  final int page;

  const FetchProductsState({
    this.products = const [],
    this.errMessage,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasReachedMax = false,
    this.page = 1,
  });

  FetchProductsState copyWith({
    List<Product>? products,
    String? errMessage,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasReachedMax,
    int? page,
  }) {
    return FetchProductsState(
      products: products ?? this.products,
      errMessage: errMessage ?? this.errMessage,
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
    isLoading,
    isLoadingMore,
    hasReachedMax,
    page,
  ];
}
