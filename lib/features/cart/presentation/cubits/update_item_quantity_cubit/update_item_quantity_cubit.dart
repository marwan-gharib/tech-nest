import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_nest/features/cart/domain/params/update_item_quantity_params.dart';
import 'package:tech_nest/features/cart/domain/use_cases/update_item_quantity_usecase.dart';
import 'package:tech_nest/core/error/failures/failure.dart';

part 'update_item_quantity_state.dart';

class UpdateItemQuantityCubit extends Cubit<UpdateItemQuantityState> {
  final UpdateItemQuantityUsecase _updateItemQuantityUsecase;

  UpdateItemQuantityCubit(this._updateItemQuantityUsecase)
    : super(const UpdateItemQuantityInitial());

  Future<void> updateQuantity({
    required int cartId,
    required int updatedQuantity,
  }) async {
    emit(const UpdateItemQuantityLoading());

    final res = await _updateItemQuantityUsecase.call(
      params: UpdateItemQuantityParams(
        cartId: cartId,
        quantity: updatedQuantity,
      ),
    );

    res.fold(
      (failure) => emit(UpdateItemQuantityFailed(failure: failure)),
      (updatedQuantity) =>
          emit(UpdateItemQuantitySuccess(updatedQuantity: updatedQuantity)),
    );
  }
}
