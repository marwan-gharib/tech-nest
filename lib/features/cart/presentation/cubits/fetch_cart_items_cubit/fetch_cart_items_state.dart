part of 'fetch_cart_items_cubit.dart';

sealed class FetchCartItemsState extends Equatable {
  const FetchCartItemsState();

  @override
  List<Object> get props => [];
}

final class FetchCartItemsInitial extends FetchCartItemsState {
  const FetchCartItemsInitial();
}

final class FetchCartItemsLoading extends FetchCartItemsState {
  const FetchCartItemsLoading();
}

final class FetchCartItemsLoaded extends FetchCartItemsState {
  final List<CartItem> cartItems;

  const FetchCartItemsLoaded({required this.cartItems});

  @override
  List<Object> get props => [cartItems];
}

final class FetchCartItemsFailed extends FetchCartItemsState {
  final String message;

  const FetchCartItemsFailed({required this.message});

  @override
  List<Object> get props => [message];
}
