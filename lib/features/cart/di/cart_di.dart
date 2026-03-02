import 'package:get_it/get_it.dart';
import 'package:tech_nest/core/services/remote/api_service/api_consumer.dart';
import 'package:tech_nest/features/cart/data/data_source/remote/cart_remote_data_source.dart';
import 'package:tech_nest/features/cart/data/repositories/cart_repo_impl.dart';
import 'package:tech_nest/features/cart/domain/repositories/cart_repo.dart';
import 'package:tech_nest/features/cart/domain/use_cases/add_to_cart_usecase.dart';
import 'package:tech_nest/features/cart/domain/use_cases/get_cart_items_usecase.dart';
import 'package:tech_nest/features/cart/domain/use_cases/remove_from_cart_usecase.dart';
import 'package:tech_nest/features/cart/presentation/cubits/fetch_cart_items_cubit/fetch_cart_items_cubit.dart';

void initCartDI(GetIt sl) {
  sl.registerLazySingleton(() => CartRemoteDataSource(sl<ApiConsumer>()));

  sl.registerLazySingleton<CartRepo>(
    () => CartRepoImpl(sl<CartRemoteDataSource>()),
  );

  sl.registerLazySingleton(() => AddToCartUsecase(sl<CartRepo>()));
  sl.registerLazySingleton(() => GetCartItemsUsecase(sl<CartRepo>()));
  sl.registerLazySingleton(() => RemoveFromCartUsecase(sl<CartRepo>()));

  sl.registerFactory(() => FetchCartItemsCubit(sl<GetCartItemsUsecase>()));
}
