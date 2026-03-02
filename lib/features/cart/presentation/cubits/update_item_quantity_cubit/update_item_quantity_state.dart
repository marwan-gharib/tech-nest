part of 'update_item_quantity_cubit.dart';

sealed class UpdateItemQuantityState extends Equatable {
  const UpdateItemQuantityState();

  @override
  List<Object> get props => [];
}

final class UpdateItemQuantityInitial extends UpdateItemQuantityState {
  const UpdateItemQuantityInitial();
}

final class UpdateItemQuantityLoading extends UpdateItemQuantityState {
  const UpdateItemQuantityLoading();
}

final class UpdateItemQuantitySuccess extends UpdateItemQuantityState {
  final int updatedQuantity;

  const UpdateItemQuantitySuccess({required this.updatedQuantity});

  @override
  List<Object> get props => [updatedQuantity];
}

final class UpdateItemQuantityFailed extends UpdateItemQuantityState {
  final String message;

  const UpdateItemQuantityFailed({required this.message});

  @override
  List<Object> get props => [message];
}
