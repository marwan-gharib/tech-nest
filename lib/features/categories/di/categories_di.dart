import 'package:get_it/get_it.dart';
import 'package:tech_nest/core/services/remote/api_service/api_consumer.dart';
import 'package:tech_nest/features/categories/data/data_source/remote/categories_remote_data_source.dart';
import 'package:tech_nest/features/categories/data/repositories/categories_repo_impl.dart';
import 'package:tech_nest/features/categories/domain/repositories/categories_repo.dart';
import 'package:tech_nest/features/categories/domain/use_cases/fetch_categories_usecase.dart';
import 'package:tech_nest/features/categories/presentation/cubit/fetch_categories_cubit.dart';

void initCategoriesDI(GetIt sl) {
  sl.registerLazySingleton(() => CategoriesRemoteDataSource(sl<ApiConsumer>()));

  sl.registerLazySingleton<CategoriesRepo>(
    () => CategoriesRepoImpl(sl<CategoriesRemoteDataSource>()),
  );

  sl.registerLazySingleton(() => FetchCategoriesUsecase(sl<CategoriesRepo>()));

  sl.registerFactory(() => FetchCategoriesCubit(sl<FetchCategoriesUsecase>()));
}
