part of 'delete_cart_item_cubit.dart';

sealed class DeleteCartItemState extends Equatable {
  const DeleteCartItemState();

  @override
  List<Object> get props => [];
}

final class DeleteCartItemInitial extends DeleteCartItemState {
  const DeleteCartItemInitial();
}

final class DeleteCartItemLoading extends DeleteCartItemState {
  const DeleteCartItemLoading();
}

final class DeleteCartItemSuccess extends DeleteCartItemState {
  final int id;
  const DeleteCartItemSuccess({required this.id});

  @override
  List<Object> get props => [id];
}

final class DeleteCartItemFailed extends DeleteCartItemState {
  final String message;

  const DeleteCartItemFailed({required this.message});

  @override
  List<Object> get props => [message];
}
