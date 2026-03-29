part of 'cart_cubit.dart';

sealed class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

final class CartInitial extends CartState {
  const CartInitial();
}

final class CartLoading extends CartState {
  const CartLoading();
}

final class CartFailed extends CartState {
  final Failure failure;

  const CartFailed({required this.failure});

  @override
  List<Object?> get props => [failure];
}

final class CartLoaded extends CartState {
  final Cart cart;
  final bool isMutating;
  final Failure? mutationFailure;

  const CartLoaded({
    required this.cart,
    this.isMutating = false,
    this.mutationFailure,
  });

  CartLoaded copyWith({
    Cart? cart,
    bool? isMutating,
    Failure? mutationFailure,
    bool clearMutationError = false,
  }) {
    return CartLoaded(
      cart: cart ?? this.cart,
      isMutating: isMutating ?? this.isMutating,
      mutationFailure: clearMutationError
          ? null
          : (mutationFailure ?? this.mutationFailure),
    );
  }

  @override
  List<Object?> get props => [cart, isMutating, mutationFailure];
}
