part of 'category_products_cubit.dart';

class CategoryProductsState extends Equatable {
  final List<Product>? products;
  final String? errMessage;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasReachedMax;

  const CategoryProductsState({
    this.products,
    this.errMessage,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasReachedMax = false,
  });

  CategoryProductsState copyWith({
    List<Product>? products,
    String? errMessage,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasReachedMax,
  }) {
    return CategoryProductsState(
      products: products ?? this.products,
      errMessage: errMessage ?? this.errMessage,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object?> get props => [
    products,
    errMessage,
    isLoading,
    isLoadingMore,
    hasReachedMax,
  ];
}
