import 'package:tech_nest/core/error/failures/failure.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_nest/features/products/domain/entities/product_entity.dart';
import 'package:tech_nest/features/products/domain/usecases/get_product_usecase.dart';

part 'get_product_state.dart';

class GetProductCubit extends Cubit<GetProductState> {
  final GetProductUsecase _getProductUsecase;

  GetProductCubit(this._getProductUsecase) : super(const GetProductInitial());

  Future<void> getProduct(int productId) async {
    emit(const GetProductLoading());
    final result = await _getProductUsecase(productId);
    result.fold(
      (failure) => emit(GetProductError(failure)),
      (product) => emit(GetProductLoaded(product)),
    );
  }
}
