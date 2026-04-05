import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_nest/core/error/failures/failure.dart';
import 'package:tech_nest/core/shared/domain/entities/product_entity.dart';
import 'package:tech_nest/core/shared/domain/params/products_params.dart';
import 'package:tech_nest/core/shared/domain/usecases/get_products_usecase.dart';
import 'package:tech_nest/core/shared/presentation/models/filter_data.dart';

part 'fetch_products_state.dart';

class FetchProductsCubit extends Cubit<FetchProductsState> {
  FetchProductsCubit(this._getProductsUsecase)
    : super(const FetchProductsInitial());

  final GetProductsUsecase _getProductsUsecase;

  ProductsParams _params = ProductsParams(limit: 10, page: 1);

  Future<void> initialFetching() async {
    emit(const FetchProductsLoading());

    final res = await _getProductsUsecase.call(params: _params);

    res.fold(
      (failure) => emit(FetchProductsError(failure)),
      (products) => emit(
        FetchProductsLoaded(
          products: products,
          hasReachedMax: products.length < _params.limit!,
          isSearchApplied: _params.search?.isNotEmpty == true,
          isFilterApplied:
              _params.categoryId != null ||
              _params.minPrice != null ||
              _params.maxPrice != null ||
              _params.sortType != null ||
              _params.orderType != null,
        ),
      ),
    );
  }

  Future<void> fetchMore() async {
    final current = state;
    if (current is! FetchProductsLoaded) return;
    if (current.isLoadingMore || current.hasReachedMax) return;

    emit(current.copyWith(isLoadingMore: true, clearLoadMoreError: true));

    final previousPage = _params.page ?? 1;
    _params = _params.copyWith(page: previousPage + 1);

    final res = await _getProductsUsecase.call(params: _params);

    res.fold(
      (failure) {
        _params = _params.copyWith(page: previousPage);
        final loaded = state;
        if (loaded is! FetchProductsLoaded) return;
        emit(loaded.copyWith(isLoadingMore: false, loadMoreFailure: failure));
      },
      (products) {
        final loaded = state;
        if (loaded is! FetchProductsLoaded) return;
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

  Future<void> search(String query) async {
    _params = _params.copyWith(search: query, page: 1);
    emit(const FetchProductsLoading());
    await _emitStateOfUsecase(
      isSearchValue: _params.search?.isNotEmpty == true,
      isFilterValue:
          _params.categoryId != null ||
          _params.minPrice != null ||
          _params.maxPrice != null,
    );
  }

  Future<void> applyFilters(FilterData filter) async {
    _params = filter.toParams().copyWith(
      search: _params.search,
      limit: 10,
      page: 1,
    );
    emit(const FetchProductsLoading());
    await _emitStateOfUsecase(
      isSearchValue: _params.search?.isNotEmpty == true,
      isFilterValue:
          true, // If applyFilters is called, we assume a filter is applied
    );
  }

  Future<void> refresh() async {
    _params = ProductsParams(page: 1, limit: 10);
    emit(const FetchProductsLoading());
    await _emitStateOfUsecase(isSearchValue: false, isFilterValue: false);
  }

  Future<void> _emitStateOfUsecase({
    required bool isSearchValue,
    required bool isFilterValue,
  }) async {
    final res = await _getProductsUsecase.call(params: _params);

    res.fold(
      (failure) => emit(FetchProductsError(failure)),
      (products) => emit(
        FetchProductsLoaded(
          products: products,
          hasReachedMax: products.length < _params.limit!,
          isSearchApplied: isSearchValue,
          isFilterApplied: isFilterValue,
        ),
      ),
    );
  }
}
