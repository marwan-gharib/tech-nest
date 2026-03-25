import 'package:get_it/get_it.dart';
import 'package:tech_nest/core/network/api_client.dart';
import 'package:tech_nest/features/products/data/data_source/remote/products_remote_data_source.dart';
import 'package:tech_nest/features/products/data/repositories/products_repo_impl.dart';
import 'package:tech_nest/features/products/domain/repositories/products_repo.dart';
import 'package:tech_nest/features/products/domain/use_cases/get_products_usecase.dart';
import 'package:tech_nest/features/products/domain/use_cases/search_suggestions_usecase.dart';
import 'package:tech_nest/features/products/presentation/cubits/fetch_products_cubit/fetch_products_cubit.dart';
import 'package:tech_nest/features/products/presentation/cubits/search_suggestions_cubit/search_suggestions_cubit.dart';

void initProductsDI(GetIt sl) {
  sl.registerLazySingleton(() => ProductsRemoteDataSource(sl<ApiClient>()));

  sl.registerLazySingleton<ProductsRepo>(
    () => ProductsRepoImpl(sl<ProductsRemoteDataSource>()),
  );

  sl.registerLazySingleton(() => GetProductsUsecase(sl<ProductsRepo>()));
  sl.registerLazySingleton(() => SearchSuggestionsUsecase(sl<ProductsRepo>()));

  sl.registerFactory(() => FetchProductsCubit(sl<GetProductsUsecase>()));
  sl.registerFactory(
    () => SearchSuggestionsCubit(sl<SearchSuggestionsUsecase>()),
  );
}
