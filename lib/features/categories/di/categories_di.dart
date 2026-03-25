import 'package:get_it/get_it.dart';
import 'package:tech_nest/core/network/api_client.dart';
import 'package:tech_nest/features/categories/data/data_source/remote/categories_remote_data_source.dart';
import 'package:tech_nest/features/categories/data/repositories/categories_repo_impl.dart';
import 'package:tech_nest/features/categories/domain/repositories/categories_repo.dart';
import 'package:tech_nest/features/categories/domain/use_cases/fetch_categories_usecase.dart';
import 'package:tech_nest/features/categories/presentation/cubits/category_products_cubit/category_products_cubit.dart';
import 'package:tech_nest/features/categories/presentation/cubits/fetch_categories_cubit/fetch_categories_cubit.dart';
import 'package:tech_nest/features/products/domain/use_cases/get_products_usecase.dart';

void initCategoriesDI(GetIt sl) {
  sl.registerLazySingleton(() => CategoriesRemoteDataSource(sl<ApiClient>()));

  sl.registerLazySingleton<CategoriesRepo>(
    () => CategoriesRepoImpl(sl<CategoriesRemoteDataSource>()),
  );

  sl.registerLazySingleton(() => FetchCategoriesUsecase(sl<CategoriesRepo>()));

  sl.registerFactory(() => FetchCategoriesCubit(sl<FetchCategoriesUsecase>()));
  sl.registerFactory(() => CategoryProductsCubit(sl<GetProductsUsecase>()));
}
