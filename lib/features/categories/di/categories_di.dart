import 'package:get_it/get_it.dart';
import 'package:tech_nest/core/network/api_client.dart';
import 'package:tech_nest/features/categories/data/datasources/remote/categories_remote_data_source.dart';
import 'package:tech_nest/features/categories/data/repositories/categories_repository_impl.dart';
import 'package:tech_nest/features/categories/domain/repositories/categories_repository.dart';
import 'package:tech_nest/features/categories/domain/usecases/fetch_categories_usecase.dart';
import 'package:tech_nest/features/categories/presentation/cubits/category_products_cubit/category_products_cubit.dart';
import 'package:tech_nest/features/categories/presentation/cubits/fetch_categories_cubit/fetch_categories_cubit.dart';
import 'package:tech_nest/features/products/domain/usecases/get_products_usecase.dart';

void initCategoriesDI(GetIt sl) {
  sl.registerLazySingleton(() => CategoriesRemoteDatasource(sl<ApiClient>()));

  sl.registerLazySingleton<CategoriesRepository>(
    () => CategoriesRepositorysitoryImpl(sl<CategoriesRemoteDatasource>()),
  );

  sl.registerLazySingleton(() => FetchCategoriesUsecase(sl<CategoriesRepository>()));

  sl.registerFactory(() => FetchCategoriesCubit(sl<FetchCategoriesUsecase>()));
  sl.registerFactory(() => CategoryProductsCubit(sl<GetProductsUsecase>()));
}
