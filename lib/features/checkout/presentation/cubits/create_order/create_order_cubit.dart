import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_nest/features/orders/domain/params/create_order_params.dart';
import 'package:tech_nest/features/orders/domain/usecases/create_order_usecase.dart';

import 'create_order_state.dart';

class CreateOrderCubit extends Cubit<CreateOrderState> {
  final CreateOrderUseCase _createOrderUseCase;

  CreateOrderCubit(this._createOrderUseCase)
    : super(const CreateOrderInitial());

  Future<void> createOrder(CreateOrderParams params) async {
    emit(const CreateOrderLoading());

    final failureOrId = await _createOrderUseCase(params: params);

    failureOrId.fold(
      (failure) => emit(CreateOrderFailed(failure)),
      (id) => emit(CreateOrderSuccess(id)),
    );
  }
}
