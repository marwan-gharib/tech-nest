import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_nest/core/domain/entities/product_entity.dart';
import 'package:tech_nest/core/domain/params/products_params.dart';
import 'package:tech_nest/core/utils/logger.dart';
import 'package:tech_nest/features/home/presentation/models/filter_data.dart';
import 'package:tech_nest/features/products/domain/use_cases/get_products_usecase.dart';
import 'package:tech_nest/core/error/failures/failure.dart';

part 'fetch_products_state.dart';

class FetchProductsCubit extends Cubit<FetchProductsState> {
  final GetProductsUsecase _getProductsUsecase;

  FetchProductsCubit(this._getProductsUsecase)
    : super(const FetchProductsState());

  ProductsParams _params = ProductsParams(limit: 10, page: 1);

  Future<void> initialFetching() async {
    emit(const FetchProductsState(isLoading: true));

    final res = await _getProductsUsecase.call(params: _params);

    res.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, failure: failure, errMessage: failure.message)),
      (products) => emit(
        state.copyWith(
          isLoading: false,
          products: products,
          hasReachedMax: products.length < _params.limit!,
        ),
      ),
    );
  }

  Future<void> fetchMore() async {
    if (state.isLoadingMore || state.hasReachedMax) return;

    AppLogger.log(_params.page.toString());

    emit(state.copyWith(isLoadingMore: true));

    _params = _params.copyWith(page: _params.page! + 1);

    final res = await _getProductsUsecase.call(params: _params);

    res.fold(
      (failure) => emit(
        state.copyWith(isLoadingMore: false, failure: failure, errMessage: failure.message),
      ),
      (products) => emit(
        state.copyWith(
          isLoadingMore: false,
          products: List.of(state.products)..addAll(products),
          hasReachedMax: products.length < _params.limit!,
          page: _params.page! + 1,
        ),
      ),
    );
  }

  Future<void> search(String query) async {
    _params = _params.copyWith(search: query, page: 1);

    await initialFetching();
  }

  Future<void> applyFilters(FilterData filter) async {
    _params = filter.toParams().copyWith(
      search: _params.search,
      limit: 10,
      page: 1,
    );

    await initialFetching();
  }

  Future<void> refresh() async {
    _params = ProductsParams(page: 1, limit: 10);

    await initialFetching();
  }
}
