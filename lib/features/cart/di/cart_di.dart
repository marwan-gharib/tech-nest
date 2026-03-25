import 'package:get_it/get_it.dart';
import 'package:tech_nest/core/network/api_client.dart';
import 'package:tech_nest/features/cart/data/data_source/remote/cart_remote_data_source.dart';
import 'package:tech_nest/features/cart/data/repositories/cart_repo_impl.dart';
import 'package:tech_nest/features/cart/domain/repositories/cart_repo.dart';
import 'package:tech_nest/features/cart/domain/use_cases/add_to_cart_usecase.dart';
import 'package:tech_nest/features/cart/domain/use_cases/get_cart_items_usecase.dart';
import 'package:tech_nest/features/cart/domain/use_cases/remove_from_cart_usecase.dart';
import 'package:tech_nest/features/cart/domain/use_cases/update_item_quantity_usecase.dart';
import 'package:tech_nest/features/cart/presentation/cubits/delete_cart_item_cubit/delete_cart_item_cubit.dart';
import 'package:tech_nest/features/cart/presentation/cubits/update_item_quantity_cubit/update_item_quantity_cubit.dart';
import 'package:tech_nest/features/cart/presentation/cubits/cart/cart_cubit.dart';

void initCartDI(GetIt sl) {
  sl.registerLazySingleton(() => CartRemoteDataSource(sl<ApiClient>()));

  sl.registerLazySingleton<CartRepo>(
    () => CartRepoImpl(sl<CartRemoteDataSource>()),
  );

  sl.registerLazySingleton(() => AddToCartUsecase(sl<CartRepo>()));
  sl.registerLazySingleton(() => GetCartItemsUsecase(sl<CartRepo>()));
  sl.registerLazySingleton(() => RemoveFromCartUsecase(sl<CartRepo>()));
  sl.registerLazySingleton(() => UpdateItemQuantityUsecase(sl<CartRepo>()));

  sl.registerFactory(
    () => UpdateItemQuantityCubit(sl<UpdateItemQuantityUsecase>()),
  );
  sl.registerFactory(() => DeleteCartItemCubit(sl<RemoveFromCartUsecase>()));
  sl.registerFactory(
    () => CartCubit(sl<GetCartItemsUsecase>(), sl<AddToCartUsecase>()),
  );
}
