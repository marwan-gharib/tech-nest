import 'package:get_it/get_it.dart';
import 'package:tech_nest/core/network/api_client.dart';
import 'package:tech_nest/core/shared/cubits/fetch_products_cubit/fetch_products_cubit.dart';
import 'package:tech_nest/core/shared/cubits/search_suggestions_cubit/search_suggestions_cubit.dart';
import 'package:tech_nest/core/shared/domain/repositories/products_shared_repository.dart';
import 'package:tech_nest/core/shared/domain/usecases/get_products_usecase.dart';
import 'package:tech_nest/core/shared/domain/usecases/search_suggestions_usecase.dart';
import 'package:tech_nest/features/products/data/datasources/remote/products_remote_data_source.dart';
import 'package:tech_nest/features/products/data/repositories/products_repository_impl.dart';

void initProductsDI(GetIt sl) {
  sl.registerLazySingleton(() => ProductsRemoteDatasource(sl<ApiClient>()));

  sl.registerLazySingleton<ProductsSharedRepository>(
    () => ProductsRepositorysitoryImpl(sl<ProductsRemoteDatasource>()),
  );

  sl.registerLazySingleton(
    () => GetProductsUsecase(sl<ProductsSharedRepository>()),
  );
  sl.registerLazySingleton(
    () => SearchSuggestionsUsecase(sl<ProductsSharedRepository>()),
  );

  sl.registerFactory(() => FetchProductsCubit(sl<GetProductsUsecase>()));
  sl.registerFactory(
    () => SearchSuggestionsCubit(sl<SearchSuggestionsUsecase>()),
  );
}
