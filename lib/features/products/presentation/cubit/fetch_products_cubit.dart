import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_nest/features/products/domain/entities/product_entity.dart';
import 'package:tech_nest/features/products/domain/use_cases/get_products_usecase.dart';

part 'fetch_products_state.dart';

class FetchProductsCubit extends Cubit<FetchProductsState> {
  final GetProductsUsecase _getProductsUsecase;

  FetchProductsCubit(this._getProductsUsecase)
    : super(const FetchProductsInitial());

  Future<List<ProductEntity>> fetchProducts({int? categoryId, int page = 1}) async {
    // emit(const FetchProductsLoading());

    final res = await _getProductsUsecase.call(
      categoryId: categoryId,
      page: page,
    );

    return res.fold<List<ProductEntity>>(
      (failure) => throw Exception(failure.message),
      (products) =>  products,
    );
  }
}
