part of 'category_products_cubit.dart';

class CategoryProductsState extends Equatable {
  final List<ProductEntity>? products;
  final String? errMessage;
  final Failure? failure;
  final int? categoryId;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasReachedMax;

  const CategoryProductsState({
    this.products,
    this.errMessage,
    this.failure,
    this.categoryId,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasReachedMax = false,
  });

  CategoryProductsState copyWith({
    List<ProductEntity>? products,
    String? errMessage,
    Failure? failure,
    int? categoryId,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasReachedMax,
  }) {
    return CategoryProductsState(
      products: products ?? this.products,
      errMessage: errMessage ?? this.errMessage,
      failure: failure ?? this.failure,
      categoryId: categoryId ?? this.categoryId,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object?> get props => [
    products,
    errMessage,
    failure,
    categoryId,
    isLoading,
    isLoadingMore,
    hasReachedMax,
  ];
}
