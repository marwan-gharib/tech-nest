import 'package:get_it/get_it.dart';
import 'package:tech_nest/core/network/api_client.dart';
import 'package:tech_nest/features/cart/domain/usecases/add_to_cart_usecase.dart';
import 'package:tech_nest/features/cart/domain/usecases/get_cart_items_usecase.dart';
import 'package:tech_nest/features/cart/data/datasources/remote/cart_remote_data_source.dart';
import 'package:tech_nest/features/cart/data/repositories/cart_repository_impl.dart';
import 'package:tech_nest/features/cart/domain/repositories/cart_repository.dart';
import 'package:tech_nest/features/cart/domain/usecases/clear_cart_usecase.dart';
import 'package:tech_nest/features/cart/domain/usecases/remove_from_cart_usecase.dart';
import 'package:tech_nest/features/cart/domain/usecases/update_item_quantity_usecase.dart';
import 'package:tech_nest/features/cart/presentation/cubits/cart/cart_cubit.dart';
import 'package:tech_nest/features/cart/presentation/cubits/delete_cart_item_cubit/delete_cart_item_cubit.dart';
import 'package:tech_nest/features/cart/presentation/cubits/update_item_quantity_cubit/update_item_quantity_cubit.dart';

void initCartDI(GetIt sl) {
  sl.registerLazySingleton(() => CartRemoteDatasource(sl<ApiClient>()));

  sl.registerLazySingleton<CartRepository>(
    () => CartRepositoryImpl(sl<CartRemoteDatasource>()),
  );

  sl.registerLazySingleton(() => AddToCartUsecase(sl<CartRepository>()));
  sl.registerLazySingleton(() => GetCartItemsUsecase(sl<CartRepository>()));
  sl.registerLazySingleton(() => RemoveFromCartUsecase(sl<CartRepository>()));
  sl.registerLazySingleton(
    () => UpdateItemQuantityUsecase(sl<CartRepository>()),
  );
  sl.registerLazySingleton(() => ClearCartUseCase(sl<CartRepository>()));

  sl.registerFactory(
    () => UpdateItemQuantityCubit(sl<UpdateItemQuantityUsecase>()),
  );
  sl.registerFactory(() => DeleteCartItemCubit(sl<RemoveFromCartUsecase>()));
  sl.registerLazySingleton(
    () => CartCubit(
      sl<GetCartItemsUsecase>(),
      sl<AddToCartUsecase>(),
      sl<ClearCartUseCase>(),
    ),
  );
}
