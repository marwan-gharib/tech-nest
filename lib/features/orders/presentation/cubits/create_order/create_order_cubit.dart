import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_nest/core/shared/presentation/cubits/cart/cart_cubit.dart';
import 'package:tech_nest/features/orders/domain/params/create_order_params.dart';
import 'package:tech_nest/features/orders/domain/usecases/create_order_usecase.dart';
import 'package:tech_nest/features/orders/presentation/cubits/create_order/create_order_state.dart';
import 'package:tech_nest/core/shared/presentation/cubits/orders_list/orders_list_cubit.dart';

class CreateOrderCubit extends Cubit<CreateOrderState> {
  final CreateOrderUseCase _createOrderUseCase;
  final CartCubit _cartCubit;
  final OrdersListCubit _ordersListCubit;

  CreateOrderCubit(
    this._createOrderUseCase,
    this._cartCubit,
    this._ordersListCubit,
  ) : super(const CreateOrderInitial());

  Future<void> createOrder(CreateOrderParams params) async {
    emit(const CreateOrderLoading());

    final failureOrId = await _createOrderUseCase(params: params);

    failureOrId.fold((failure) => emit(CreateOrderFailed(failure)), (id) {
      // Clear cart locally by refetching from server (which should be empty)
      _cartCubit.fetchCart();

      // Background refresh orders list to show the new order
      _ordersListCubit.fetchOrders(showLoading: false);

      emit(CreateOrderSuccess(id));
    });
  }
}
