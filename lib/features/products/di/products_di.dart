import 'package:get_it/get_it.dart';
import 'package:tech_nest/core/network/api_client.dart';
import 'package:tech_nest/features/products/data/datasources/remote/products_remote_data_source.dart';
import 'package:tech_nest/features/products/data/repositories/products_repository_impl.dart';
import 'package:tech_nest/features/products/domain/repositories/products_repository.dart';
import 'package:tech_nest/features/products/domain/usecases/get_products_usecase.dart';
import 'package:tech_nest/features/products/domain/usecases/search_suggestions_usecase.dart';
import 'package:tech_nest/features/products/presentation/cubits/fetch_products_cubit/fetch_products_cubit.dart';
import 'package:tech_nest/features/products/presentation/cubits/search_suggestions_cubit/search_suggestions_cubit.dart';

void initProductsDI(GetIt sl) {
  sl.registerLazySingleton(() => ProductsRemoteDatasource(sl<ApiClient>()));

  sl.registerLazySingleton<ProductsRepository>(
    () => ProductsRepositorysitoryImpl(sl<ProductsRemoteDatasource>()),
  );

  sl.registerLazySingleton(() => GetProductsUsecase(sl<ProductsRepository>()));
  sl.registerLazySingleton(() => SearchSuggestionsUsecase(sl<ProductsRepository>()));

  sl.registerFactory(() => FetchProductsCubit(sl<GetProductsUsecase>()));
  sl.registerFactory(
    () => SearchSuggestionsCubit(sl<SearchSuggestionsUsecase>()),
  );
}
