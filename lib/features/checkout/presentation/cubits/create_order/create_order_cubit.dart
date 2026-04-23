import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_nest/features/cart/domain/usecases/clear_cart_usecase.dart';
import 'package:tech_nest/features/orders/domain/params/create_order_params.dart';
import 'package:tech_nest/features/orders/domain/usecases/create_order_usecase.dart';
import 'create_order_state.dart';

class CreateOrderCubit extends Cubit<CreateOrderState> {
  final CreateOrderUseCase _createOrderUseCase;
  final ClearCartUseCase _clearCartUseCase;

  CreateOrderCubit(
    this._createOrderUseCase,
    this._clearCartUseCase,
  ) : super(const CreateOrderInitial());

  Future<void> createOrder(CreateOrderParams params) async {
    emit(const CreateOrderLoading());

    final failureOrId = await _createOrderUseCase(params: params);

    failureOrId.fold(
      (failure) => emit(CreateOrderFailed(failure)),
      (id) async {
        // Clear cart domain-side
        await _clearCartUseCase();
        
        emit(CreateOrderSuccess(id));
      },
    );
  }
}
