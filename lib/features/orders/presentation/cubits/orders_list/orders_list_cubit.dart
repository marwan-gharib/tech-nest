import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_nest/features/orders/domain/usecases/get_user_orders_usecase.dart';
import 'package:tech_nest/features/orders/presentation/cubits/orders_list/orders_list_state.dart';

class OrdersListCubit extends Cubit<OrdersListState> {
  final GetUserOrdersUseCase _getUserOrdersUseCase;

  OrdersListCubit(this._getUserOrdersUseCase)
    : super(const OrdersListInitial());

  Future<void> fetchOrders() async {
    emit(const OrdersListLoading());

    final failureOrOrders = await _getUserOrdersUseCase();

    failureOrOrders.fold(
      (failure) => emit(OrdersListFailed(failure)),
      (orders) => emit(OrdersListLoaded(orders)),
    );
  }
}
