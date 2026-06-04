import 'package:tech_nest/core/error/failures/failure.dart';
import 'package:equatable/equatable.dart';

sealed class CreateOrderState extends Equatable {
  const CreateOrderState();

  @override
  List<Object?> get props => [];
}

class CreateOrderInitial extends CreateOrderState {
  const CreateOrderInitial();
}

class CreateOrderLoading extends CreateOrderState {
  const CreateOrderLoading();
}

class CreateOrderSuccess extends CreateOrderState {
  final int orderId;

  const CreateOrderSuccess(this.orderId);

  @override
  List<Object?> get props => [orderId];
}

class CreateOrderFailed extends CreateOrderState {
  final Failure failure;

  const CreateOrderFailed(this.failure);

  @override
  List<Object?> get props => [failure];
}
