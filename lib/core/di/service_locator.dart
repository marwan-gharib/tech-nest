import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tech_nest/core/network/api_client.dart';
import 'package:tech_nest/core/network/dio_client.dart';
import 'package:tech_nest/core/network/interceptors/auth_interceptor.dart';
import 'package:tech_nest/core/network/interceptors/error_interceptor.dart';
import 'package:tech_nest/core/network/interceptors/logging_interceptor.dart';
import 'package:tech_nest/core/services/auth/auth_notifier.dart';
import 'package:tech_nest/core/services/local/cache/cache_service.dart';
import 'package:tech_nest/core/services/local/cache/shared_preferences_service.dart';
import 'package:tech_nest/core/services/local/secure/secure_storage_impl.dart';
import 'package:tech_nest/core/services/local/secure/secure_storage_service.dart';
import 'package:tech_nest/core/theme/cubit/theme_cubit.dart';
import 'package:tech_nest/features/auth/di/auth_di.dart';
import 'package:tech_nest/features/cart/di/cart_di.dart';
import 'package:tech_nest/features/categories/di/categories_di.dart';
import 'package:tech_nest/features/products/di/products_di.dart';

final GetIt sl = GetIt.instance;

Future<void> initDependencies() async {
  final SharedPreferences pref = await SharedPreferences.getInstance();

  // ── Local services (no dependencies) ──────────────────────────────────────
  sl.registerLazySingleton<SecureStorageService>(
    () => SecureStorageServiceImpl(const FlutterSecureStorage()),
  );
  sl.registerLazySingleton<CacheService>(() => SharedPreferencesService(pref));

  sl.registerLazySingleton(() => AuthNotifier());

  // ── Interceptors (must be registered BEFORE DioClient) ────────────────────
  sl.registerLazySingleton(() => AuthInterceptor(sl<SecureStorageService>()));
  sl.registerLazySingleton(
    () => ErrorInterceptor(sl<CacheService>(), sl<AuthNotifier>()),
  );
  sl.registerLazySingleton(() => LoggingInterceptor());

  // ── Network ───────────────────────────────────────────────────────────────
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton<ApiClient>(
    () => DioClient(
      dio: sl<Dio>(),
      authInterceptor: sl<AuthInterceptor>(),
      errorInterceptor: sl<ErrorInterceptor>(),
      loggingInterceptor: sl<LoggingInterceptor>(),
    ),
  );

  // ── Theme ─────────────────────────────────────────────────────────────────
  sl.registerFactory(() => ThemeCubit(sl<CacheService>()));

  // ── Features ──────────────────────────────────────────────────────────────
  initAuthDI(sl);
  initProductsDI(sl);
  initCategoriesDI(sl);
  initCartDI(sl);
}
