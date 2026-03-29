import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_nest/features/cart/domain/use_cases/remove_from_cart_usecase.dart';
import 'package:tech_nest/core/error/failures/failure.dart';

part 'delete_cart_item_state.dart';

class DeleteCartItemCubit extends Cubit<DeleteCartItemState> {
  final RemoveFromCartUsecase _removeFromCartUsecase;

  DeleteCartItemCubit(this._removeFromCartUsecase)
    : super(const DeleteCartItemInitial());

  Future<void> removeItem({required int cartId}) async {
    emit(const DeleteCartItemLoading());

    final res = await _removeFromCartUsecase.call(cartId: cartId);

    res.fold(
      (failure) => emit(DeleteCartItemFailed(failure: failure)),
      (id) => emit(DeleteCartItemSuccess(id: id)),
    );
  }
}
