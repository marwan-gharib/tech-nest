import 'package:get_it/get_it.dart';
import 'package:tech_nest/features/checkout/presentation/cubits/create_order/create_order_cubit.dart';
import 'package:tech_nest/features/orders/domain/usecases/create_order_usecase.dart';

void initCheckoutDI(GetIt sl) {
  sl.registerFactory(() => CreateOrderCubit(sl<CreateOrderUseCase>()));
}
