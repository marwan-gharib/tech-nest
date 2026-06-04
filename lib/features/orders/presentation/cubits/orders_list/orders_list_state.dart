import 'package:tech_nest/core/error/failures/failure.dart';
import 'package:equatable/equatable.dart';
import 'package:tech_nest/features/orders/domain/entities/order_entity.dart';

sealed class OrdersListState extends Equatable {
  const OrdersListState();

  @override
  List<Object?> get props => [];
}

class OrdersListInitial extends OrdersListState {
  const OrdersListInitial();
}

class OrdersListLoading extends OrdersListState {
  const OrdersListLoading();
}

class OrdersListLoaded extends OrdersListState {
  final List<OrderEntity> orders;

  const OrdersListLoaded(this.orders);

  OrdersListLoaded copyWith({
    List<OrderEntity>? orders,
  }) {
    return OrdersListLoaded(
      orders ?? this.orders,
    );
  }

  @override
  List<Object?> get props => [orders];
}

class OrdersListFailed extends OrdersListState {
  final Failure failure;

  const OrdersListFailed(this.failure);

  @override
  List<Object?> get props => [failure];
}
