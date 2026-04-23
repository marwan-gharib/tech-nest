import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_nest/features/orders/domain/usecases/cancel_order_usecase.dart';
import 'package:tech_nest/features/orders/domain/usecases/get_order_details_usecase.dart';
import 'package:tech_nest/features/orders/domain/enums/order_status.dart';
import 'package:tech_nest/features/orders/presentation/cubits/order_details/order_details_state.dart';
import 'package:tech_nest/features/orders/presentation/cubits/orders_list/orders_list_cubit.dart';

class OrderDetailsCubit extends Cubit<OrderDetailsState> {
  final GetOrderDetailsUseCase _getOrderDetailsUseCase;
  final CancelOrderUseCase _cancelOrderUseCase;
  final OrdersListCubit _ordersListCubit;

  OrderDetailsCubit(
    this._getOrderDetailsUseCase,
    this._cancelOrderUseCase,
    this._ordersListCubit,
  ) : super(const OrderDetailsInitial());

  Future<void> fetchOrderDetails(int orderId) async {
    emit(const OrderDetailsLoading());

    final failureOrOrder = await _getOrderDetailsUseCase(orderId: orderId);

    failureOrOrder.fold(
      (failure) => emit(OrderDetailsFailed(failure)),
      (order) => emit(OrderDetailsLoaded(order: order)),
    );
  }

  Future<void> cancelOrder(int orderId) async {
    final currentState = state;
    if (currentState is! OrderDetailsLoaded) return;

    emit(currentState.clearFailure().copyWith(isCancelling: true));

    final result = await _cancelOrderUseCase(orderId: orderId);

    result.fold(
      (failure) => emit(
        currentState.copyWith(isCancelling: false, cancelFailure: failure),
      ),
      (_) {
        // Mutate local state instead of full refresh
        final updatedOrder = currentState.order.copyWith(
          status: OrderStatus.cancelled,
        );

        emit(
          currentState.clearFailure().copyWith(
            order: updatedOrder,
            isCancelling: false,
            isCancelledSuccessfully: true,
          ),
        );

        // Update the list cubit as well
        _ordersListCubit.updateOrderStatusLocally(orderId, OrderStatus.cancelled);
      },
    );
  }
}
