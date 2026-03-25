import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_nest/core/domain/params/add_to_cart_params.dart';
import 'package:tech_nest/features/cart/domain/entities/cart.dart';
import 'package:tech_nest/features/cart/domain/use_cases/add_to_cart_usecase.dart';
import 'package:tech_nest/features/cart/domain/use_cases/get_cart_items_usecase.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final GetCartItemsUsecase _getCartItemsUsecase;
  final AddToCartUsecase _addToCartUsecase;

  CartCubit(this._getCartItemsUsecase, this._addToCartUsecase)
    : super(const CartInitial());

  Future<void> fetchCart() async {
    emit(const CartLoading());

    final res = await _getCartItemsUsecase.call();

    res.fold(
      (failure) => emit(CartFailed(message: failure.message)),
      (cart) => emit(CartLoaded(cart: cart)),
    );
  }

  Future<void> add({required int productId, required int quantity}) async {
    final currentState = state;
    if (currentState is! CartLoaded) return;

    emit(const CartLoading());

    final res = await _addToCartUsecase.call(
      params: AddToCartParams(productId: productId, quantity: quantity),
    );

    res.fold((failure) => emit(CartFailed(message: failure.message)), (
      newCartItem,
    ) {
      final currentItems = currentState.cart.items;

      final index = currentItems.indexWhere(
        (item) => item.product.id == newCartItem.product.id,
      );

      if (index != -1) {
        final oldItem = currentItems[index];

        currentItems[index] = oldItem.copyWith(
          quantity: oldItem.quantity + newCartItem.quantity,
        );
      } else {
        currentItems.add(newCartItem);
      }

      emit(
        currentState.copyWith(
          cart: currentState.cart.copyWith(items: currentItems),
        ),
      );
    });
  }

  void removeItemLocally({required int id}) {
    final currentState = state;
    if (currentState is! CartLoaded) return;

    final updatedCart = currentState.cart.items
        .where((item) => item.id != id)
        .toList();

    final newCart = currentState.cart.recalculate(updatedCart);

    emit(currentState.copyWith(cart: newCart));
  }
}
