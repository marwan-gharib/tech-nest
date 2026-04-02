import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_nest/core/shared/domain/params/add_to_cart_params.dart';
import 'package:tech_nest/core/error/failures/failure.dart';
import 'package:tech_nest/features/cart/domain/entities/cart_entity.dart';
import 'package:tech_nest/features/cart/domain/usecases/add_to_cart_usecase.dart';
import 'package:tech_nest/features/cart/domain/usecases/get_cart_items_usecase.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit(this._getCartItemsUsecase, this._addToCartUsecase)
    : super(const CartInitial());

  final GetCartItemsUsecase _getCartItemsUsecase;
  final AddToCartUsecase _addToCartUsecase;

  Future<void> fetchCart() async {
    emit(const CartLoading());

    final res = await _getCartItemsUsecase.call();

    res.fold(
      (failure) => emit(CartFailed(failure: failure)),
      (cart) => emit(CartLoaded(cart: cart)),
    );
  }

  Future<void> add({required int productId, required int quantity}) async {
    final currentState = state;
    if (currentState is! CartLoaded) return;

    emit(
      currentState.copyWith(
        isMutating: true,
        clearMutationError: true,
      ),
    );

    final res = await _addToCartUsecase.call(
      params: AddToCartParams(productId: productId, quantity: quantity),
    );

    res.fold(
      (failure) {
        final latest = state;
        if (latest is! CartLoaded) return;
        emit(
          latest.copyWith(
            isMutating: false,
            mutationFailure: failure,
          ),
        );
      },
      (newCartItem) {
        final baseline = currentState;
        final currentItems = List.of(baseline.cart.items);

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

        final updatedCart = baseline.cart.recalculate(currentItems);
        emit(
          baseline.copyWith(
            cart: updatedCart,
            isMutating: false,
            clearMutationError: true,
          ),
        );
      },
    );
  }

  void clearMutationError() {
    final currentState = state;
    if (currentState is! CartLoaded) return;
    if (currentState.mutationFailure == null) return;
    emit(currentState.copyWith(clearMutationError: true));
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

  void updateItemQuantityLocally({
    required int id,
    required int quantity,
  }) {
    final currentState = state;
    if (currentState is! CartLoaded) return;

    final updatedItems = currentState.cart.items.map((item) {
      if (item.id == id) {
        return item.copyWith(quantity: quantity);
      }
      return item;
    }).toList();

    final newCart = currentState.cart.recalculate(updatedItems);
    emit(currentState.copyWith(cart: newCart));
  }
}
