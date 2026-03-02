import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_nest/features/cart/domain/entities/cart_item.dart';
import 'package:tech_nest/features/cart/domain/use_cases/get_cart_items_usecase.dart';

part 'fetch_cart_items_state.dart';

class FetchCartItemsCubit extends Cubit<FetchCartItemsState> {
  final GetCartItemsUsecase _getCartItemsUsecase;

  FetchCartItemsCubit(this._getCartItemsUsecase)
    : super(const FetchCartItemsInitial());

  Future<void> fetchCart() async {
    emit(const FetchCartItemsLoading());

    final res = await _getCartItemsUsecase.call();

    res.fold(
      (failure) => emit(FetchCartItemsFailed(message: failure.message)),
      (cartItems) => emit(FetchCartItemsLoaded(cartItems: cartItems)),
    );
  }
}
