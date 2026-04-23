import 'package:get_it/get_it.dart';
import 'package:tech_nest/core/network/api_client.dart';
import 'package:tech_nest/core/shared/domain/usecases/get_user_orders_usecase.dart';
import 'package:tech_nest/features/orders/data/datasources/remote/orders_remote_datasource.dart';
import 'package:tech_nest/features/orders/data/repositories/orders_repository_impl.dart';
import 'package:tech_nest/features/orders/domain/repositories/orders_repository.dart';
import 'package:tech_nest/features/orders/domain/usecases/cancel_order_usecase.dart';
import 'package:tech_nest/features/orders/domain/usecases/create_order_usecase.dart';
import 'package:tech_nest/features/orders/domain/usecases/get_order_details_usecase.dart';
import 'package:tech_nest/features/orders/presentation/cubits/order_details/order_details_cubit.dart';
import 'package:tech_nest/features/orders/presentation/cubits/orders_list/orders_list_cubit.dart';

void initOrdersDI(GetIt sl) {
  sl.registerLazySingleton(() => OrdersRemoteDatasource(sl<ApiClient>()));

  sl.registerLazySingleton<OrdersRepository>(
    () => OrdersRepositoryImpl(sl<OrdersRemoteDatasource>()),
  );
  sl.registerLazySingleton(() => CreateOrderUseCase(sl<OrdersRepository>()));
  sl.registerLazySingleton(() => GetUserOrdersUseCase(sl<OrdersRepository>()));
  sl.registerLazySingleton(
    () => GetOrderDetailsUseCase(sl<OrdersRepository>()),
  );
  sl.registerLazySingleton(() => CancelOrderUseCase(sl<OrdersRepository>()));

  sl.registerLazySingleton(() => OrdersListCubit(sl<GetUserOrdersUseCase>()));
  sl.registerFactory(
    () => OrderDetailsCubit(
      sl<GetOrderDetailsUseCase>(),
      sl<CancelOrderUseCase>(),
      sl<OrdersListCubit>(),
    ),
  );
}
