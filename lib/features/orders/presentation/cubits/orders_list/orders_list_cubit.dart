import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_nest/features/orders/domain/usecases/get_user_orders_usecase.dart';
import 'package:tech_nest/features/orders/domain/enums/order_status.dart';
import 'orders_list_state.dart';

class OrdersListCubit extends Cubit<OrdersListState> {
  final GetUserOrdersUseCase _getUserOrdersUseCase;

  OrdersListCubit(this._getUserOrdersUseCase)
    : super(const OrdersListInitial());

  Future<void> fetchOrders({bool showLoading = true}) async {
    if (showLoading) {
      emit(const OrdersListLoading());
    }

    final failureOrOrders = await _getUserOrdersUseCase();

    failureOrOrders.fold(
      (failure) => emit(OrdersListFailed(failure)),
      (orders) => emit(OrdersListLoaded(orders)),
    );
  }

  void updateOrderStatusLocally(int orderId, OrderStatus newStatus) {
    final currentState = state;
    if (currentState is! OrdersListLoaded) return;

    final updatedOrders = currentState.orders.map((order) {
      if (order.id == orderId) {
        return order.copyWith(status: newStatus);
      }
      return order;
    }).toList();

    emit(currentState.copyWith(orders: updatedOrders));
  }
}
