part of 'cart_cubit.dart';

sealed class CartState extends Equatable {
  const CartState();

  @override
  List<Object> get props => [];
}

final class CartInitial extends CartState {
  const CartInitial();
}

final class CartLoading extends CartState {
  const CartLoading();
}

final class CartLoaded extends CartState {
  final Cart cart;

  const CartLoaded({required this.cart});

  CartLoaded copyWith({Cart? cart}) {
    return CartLoaded(cart: cart ?? this.cart);
  }

  @override
  List<Object> get props => [cart];
}

final class CartFailed extends CartState {
  final String message;

  const CartFailed({required this.message});

  @override
  List<Object> get props => [message];
}
