import 'package:get_it/get_it.dart';
import 'package:tech_nest/core/services/remote/api_service/api_consumer.dart';
import 'package:tech_nest/features/products/data/data_source/remote/products_remote_data_source.dart';
import 'package:tech_nest/features/products/data/repositories/products_repo_impl.dart';
import 'package:tech_nest/features/products/domain/repositories/products_repo.dart';
import 'package:tech_nest/features/products/domain/use_cases/get_products_usecase.dart';

void initProductsDI(GetIt sl) {
  sl.registerLazySingleton(() => ProductsRemoteDataSource(sl<ApiConsumer>()));

  sl.registerLazySingleton<ProductsRepo>(
    () => ProductsRepoImpl(sl<ProductsRemoteDataSource>()),
  );

  sl.registerLazySingleton(() => GetProductsUsecase(sl<ProductsRepo>()));
}
