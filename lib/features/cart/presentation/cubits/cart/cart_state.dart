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

final class CartNoConnection extends CartState {
  const CartNoConnection();
}

final class CartError extends CartState {
  final String message;

  const CartError({required this.message});

  @override
  List<Object?> get props => [message];
}

final class CartLoaded extends CartState {
  final Cart cart;
  final bool isMutating;
  final String? mutationErrorMessage;
  final bool mutationErrorIsNetwork;

  const CartLoaded({
    required this.cart,
    this.isMutating = false,
    this.mutationErrorMessage,
    this.mutationErrorIsNetwork = false,
  });

  CartLoaded copyWith({
    Cart? cart,
    bool? isMutating,
    String? mutationErrorMessage,
    bool? mutationErrorIsNetwork,
    bool clearMutationError = false,
  }) {
    return CartLoaded(
      cart: cart ?? this.cart,
      isMutating: isMutating ?? this.isMutating,
      mutationErrorMessage: clearMutationError
          ? null
          : (mutationErrorMessage ?? this.mutationErrorMessage),
      mutationErrorIsNetwork: clearMutationError
          ? false
          : (mutationErrorIsNetwork ?? this.mutationErrorIsNetwork),
    );
  }

  @override
  List<Object?> get props => [
    cart,
    isMutating,
    mutationErrorMessage,
    mutationErrorIsNetwork,
  ];
}
