import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_nest/features/cart/domain/params/add_to_cart_params.dart';
import 'package:tech_nest/features/cart/domain/use_cases/add_to_cart_usecase.dart';

part 'add_product_to_cart_state.dart';

class AddProductToCartCubit extends Cubit<AddProductToCartState> {
  final AddToCartUsecase _addToCartUsecase;

  AddProductToCartCubit(this._addToCartUsecase)
    : super(const AddProductToCartState());

  Future<void> add({required int productId, required int quantity}) async {
    emit(state.copyWith(isLoading: true, isSuccess: false, message: ''));

    final res = await _addToCartUsecase.call(
      params: AddToCartParams(productId: productId, quantity: quantity),
    );

    res.fold(
      (failure) => emit(
        state.copyWith(
          isLoading: false,
          isSuccess: false,
          message: failure.message,
        ),
      ),
      (_) =>
          emit(state.copyWith(isSuccess: true, isLoading: false, message: '')),
    );
  }
}
