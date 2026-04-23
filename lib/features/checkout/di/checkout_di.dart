import 'package:get_it/get_it.dart';
import 'package:tech_nest/features/cart/domain/usecases/clear_cart_usecase.dart';
import 'package:tech_nest/features/checkout/presentation/cubits/create_order/create_order_cubit.dart';
import 'package:tech_nest/features/orders/domain/usecases/create_order_usecase.dart';

void initCheckoutDI(GetIt sl) {
  sl.registerFactory(
    () => CreateOrderCubit(
      sl<CreateOrderUseCase>(),
      sl<ClearCartUseCase>(),
    ),
  );
}
