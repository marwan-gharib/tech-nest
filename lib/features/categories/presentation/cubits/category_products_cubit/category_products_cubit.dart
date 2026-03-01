import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_nest/core/entities/product_entity.dart';
import 'package:tech_nest/core/params/products_params.dart';
import 'package:tech_nest/features/products/domain/use_cases/get_products_usecase.dart';

part 'category_products_state.dart';

class CategoryProductsCubit extends Cubit<CategoryProductsState> {
  final GetProductsUsecase _getProductsUsecase;

  CategoryProductsCubit(this._getProductsUsecase)
    : super(const CategoryProductsState());

  ProductsParams _params = ProductsParams(limit: 10);

  Future<void> fetchInitialCategoryProducts({required int categoryId}) async {
    emit(state.copyWith(isLoading: true));

    _params = _params.copyWith(page: 1, categoryId: categoryId);

    final res = await _getProductsUsecase.call(params: _params);

    res.fold(
      (failure) =>
          emit(state.copyWith(errMessage: failure.message, isLoading: false)),
      (products) => emit(
        state.copyWith(
          products: products,
          isLoading: false,
          hasReachedMax: products.length < _params.limit!,
        ),
      ),
    );
  }

  Future<void> fetchMoreCategoryProducts() async {
    if (state.isLoadingMore || state.hasReachedMax) return;

    emit(state.copyWith(isLoadingMore: true));

    _params = _params.copyWith(page: _params.page! + 1);

    final res = await _getProductsUsecase.call(params: _params);

    res.fold(
      (failure) => emit(
        state.copyWith(errMessage: failure.message, isLoadingMore: false),
      ),
      (products) => emit(
        state.copyWith(
          products: List.of(state.products!)..addAll(products),
          isLoadingMore: false,
          hasReachedMax: products.length < _params.limit!,
        ),
      ),
    );
  }
}
