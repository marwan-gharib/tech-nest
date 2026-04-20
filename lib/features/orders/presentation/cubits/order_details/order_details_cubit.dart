import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_nest/features/orders/domain/usecases/cancel_order_usecase.dart';
import 'package:tech_nest/features/orders/domain/usecases/get_order_details_usecase.dart';
import 'package:tech_nest/features/orders/presentation/cubits/order_details/order_details_state.dart';

class OrderDetailsCubit extends Cubit<OrderDetailsState> {
  final GetOrderDetailsUseCase _getOrderDetailsUseCase;
  final CancelOrderUseCase _cancelOrderUseCase;

  OrderDetailsCubit(this._getOrderDetailsUseCase, this._cancelOrderUseCase)
    : super(const OrderDetailsInitial());

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
        emit(
          currentState.clearFailure().copyWith(
            isCancelling: false,
            isCancelledSuccessfully: true,
          ),
        );
        // Refetch to get the updated status from server
        fetchOrderDetails(orderId);
      },
    );
  }
}
