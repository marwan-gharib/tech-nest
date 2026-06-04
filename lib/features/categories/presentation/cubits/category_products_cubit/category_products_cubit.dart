import 'package:tech_nest/core/error/failures/failure.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_nest/features/products/domain/entities/product_entity.dart';
import 'package:tech_nest/features/products/domain/params/products_params.dart';
import 'package:tech_nest/features/products/domain/usecases/get_products_usecase.dart';

part 'category_products_state.dart';

class CategoryProductsCubit extends Cubit<CategoryProductsState> {
  CategoryProductsCubit(this._getProductsUsecase)
    : super(const CategoryProductsInitial());

  final GetProductsUsecase _getProductsUsecase;

  ProductsParams _params = ProductsParams(limit: 10);

  int? _lastCategoryId;

  Future<void> fetchInitialCategoryProducts({required int categoryId}) async {
    _lastCategoryId = categoryId;
    emit(const CategoryProductsLoading());

    _params = _params.copyWith(page: 1, categoryId: categoryId);

    final res = await _getProductsUsecase.call(params: _params);

    res.fold(
      (failure) => emit(CategoryProductsError(failure)),
      (products) => emit(
        CategoryProductsLoaded(
          products: products,
          hasReachedMax: products.length < _params.limit!,
        ),
      ),
    );
  }

  Future<void> fetchMoreCategoryProducts() async {
    final current = state;
    if (current is! CategoryProductsLoaded) return;
    if (current.isLoadingMore || current.hasReachedMax) return;

    emit(current.copyWith(isLoadingMore: true, clearLoadMoreError: true));

    final previousPage = _params.page ?? 1;
    _params = _params.copyWith(page: previousPage + 1);

    final res = await _getProductsUsecase.call(params: _params);

    res.fold(
      (failure) {
        _params = _params.copyWith(page: previousPage);
        final loaded = state;
        if (loaded is! CategoryProductsLoaded) return;
        emit(loaded.copyWith(isLoadingMore: false, loadMoreFailure: failure));
      },
      (products) {
        final loaded = state;
        if (loaded is! CategoryProductsLoaded) return;
        emit(
          loaded.copyWith(
            isLoadingMore: false,
            products: List.of(loaded.products)..addAll(products),
            hasReachedMax: products.length < _params.limit!,
            clearLoadMoreError: true,
          ),
        );
      },
    );
  }

  void retryInitialCategoryProducts() {
    final id = _lastCategoryId;
    if (id != null) {
      fetchInitialCategoryProducts(categoryId: id);
    }
  }
}
