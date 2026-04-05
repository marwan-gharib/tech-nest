import 'package:get_it/get_it.dart';
import 'package:tech_nest/core/network/api_client.dart';
import 'package:tech_nest/core/shared/presentation/cubits/cart/cart_cubit.dart';
import 'package:tech_nest/core/shared/domain/repositories/cart_shared_repository.dart';
import 'package:tech_nest/core/shared/domain/usecases/add_to_cart_usecase.dart';
import 'package:tech_nest/core/shared/domain/usecases/get_cart_items_usecase.dart';
import 'package:tech_nest/features/cart/data/datasources/remote/cart_remote_data_source.dart';
import 'package:tech_nest/features/cart/data/repositories/cart_repository_impl.dart';
import 'package:tech_nest/features/cart/domain/repositories/cart_repository.dart';
import 'package:tech_nest/features/cart/domain/usecases/remove_from_cart_usecase.dart';
import 'package:tech_nest/features/cart/domain/usecases/update_item_quantity_usecase.dart';
import 'package:tech_nest/features/cart/presentation/cubits/delete_cart_item_cubit/delete_cart_item_cubit.dart';
import 'package:tech_nest/features/cart/presentation/cubits/update_item_quantity_cubit/update_item_quantity_cubit.dart';

void initCartDI(GetIt sl) {
  sl.registerLazySingleton(() => CartRemoteDatasource(sl<ApiClient>()));

  sl.registerLazySingleton<CartRepositoryImpl>(
    () => CartRepositoryImpl(sl<CartRemoteDatasource>()),
  );

  sl.registerLazySingleton<CartRepository>(() => sl<CartRepositoryImpl>());
  sl.registerLazySingleton<CartSharedRepository>(
    () => sl<CartRepositoryImpl>(),
  );

  sl.registerLazySingleton(() => AddToCartUsecase(sl<CartSharedRepository>()));
  sl.registerLazySingleton(
    () => GetCartItemsUsecase(sl<CartSharedRepository>()),
  );
  sl.registerLazySingleton(() => RemoveFromCartUsecase(sl<CartRepository>()));
  sl.registerLazySingleton(
    () => UpdateItemQuantityUsecase(sl<CartRepository>()),
  );

  sl.registerFactory(
    () => UpdateItemQuantityCubit(sl<UpdateItemQuantityUsecase>()),
  );
  sl.registerFactory(() => DeleteCartItemCubit(sl<RemoveFromCartUsecase>()));
  sl.registerFactory(
    () => CartCubit(sl<GetCartItemsUsecase>(), sl<AddToCartUsecase>()),
  );
}
