import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tech_nest/core/local/cache/cache_service.dart';
import 'package:tech_nest/core/local/cache/shared_preferences_service.dart';
import 'package:tech_nest/core/local/secure/secure_storage_client.dart';
import 'package:tech_nest/core/local/secure/secure_storage_impl.dart';
import 'package:tech_nest/core/network/api_client.dart';
import 'package:tech_nest/core/network/dio_client.dart';
import 'package:tech_nest/core/network/interceptors/auth_interceptor.dart';
import 'package:tech_nest/core/network/interceptors/error_interceptor.dart';
import 'package:tech_nest/core/network/interceptors/locale_interceptor.dart';
import 'package:tech_nest/core/services/auth/auth_notifier.dart';
import 'package:tech_nest/core/shared/data/datasources/local/user_local_datasource.dart';
import 'package:tech_nest/core/shared/presentation/cubits/locale/locale_cubit.dart';
import 'package:tech_nest/core/theme/cubit/theme_cubit.dart';
import 'package:tech_nest/features/auth/di/auth_di.dart';
import 'package:tech_nest/features/cart/di/cart_di.dart';
import 'package:tech_nest/features/categories/di/categories_di.dart';
import 'package:tech_nest/features/products/di/products_di.dart';
import 'package:tech_nest/features/settings/di/settings_di.dart';
import 'package:tech_nest/features/orders/di/orders_di.dart';

final GetIt sl = GetIt.instance;

Future<void> initDependencies() async {
  final SharedPreferences pref = await SharedPreferences.getInstance();

  // ── Local services (no dependencies) ──────────────────────────────────────
  sl.registerLazySingleton<SecureStorageClient>(
    () => SecureStorageClientImpl(const FlutterSecureStorage()),
  );
  sl.registerLazySingleton<CacheService>(() => SharedPreferencesService(pref));
  sl.registerLazySingleton<UserLocalDataSource>(
    () => UserLocalDataSourceImpl(sl<CacheService>()),
  );

  sl.registerLazySingleton(() => AuthNotifier());

  // ── Interceptors (must be registered BEFORE DioClient) ────────────────────
  sl.registerLazySingleton(() => AuthInterceptor(sl<SecureStorageClient>()));
  sl.registerLazySingleton(() => LocaleInterceptor());
  sl.registerLazySingleton(
    () => ErrorInterceptor(
      sl<CacheService>(),
      sl<AuthNotifier>(),
      sl<SecureStorageClient>(),
    ),
  );

  // ── Network ───────────────────────────────────────────────────────────────
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton<ApiClient>(
    () => DioClient(
      dio: sl<Dio>(),
      authInterceptor: sl<AuthInterceptor>(),
      localeInterceptor: sl<LocaleInterceptor>(),
      errorInterceptor: sl<ErrorInterceptor>(),
    ),
  );

  // ── Theme ─────────────────────────────────────────────────────────────────
  sl.registerLazySingleton(() => ThemeCubit(sl<CacheService>()));
  sl.registerLazySingleton(() => LocaleCubit(sl<CacheService>()));

  // ── Features ──────────────────────────────────────────────────────────────
  initAuthDI(sl);
  initProductsDI(sl);
  initCategoriesDI(sl);
  initCartDI(sl);
  initSettingsDI(sl);
  initOrdersDI(sl);
}
