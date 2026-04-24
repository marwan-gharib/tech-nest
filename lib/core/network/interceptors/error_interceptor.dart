import 'package:dio/dio.dart';
import 'package:tech_nest/core/constants/app_constants.dart';
import 'package:tech_nest/core/local/secure/secure_storage_client.dart';
import 'package:tech_nest/core/local/cache/cache_service.dart';
import 'package:tech_nest/features/auth/presentation/notifiers/auth_notifier.dart';

class ErrorInterceptor extends Interceptor {
  final CacheService _cacheService;
  final AuthNotifier _authNotifier;
  final SecureStorageClient _secureStorageClient;

  ErrorInterceptor(
    this._cacheService,
    this._authNotifier,
    this._secureStorageClient,
  );

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final bool skipAuth =
        err.requestOptions.extra[AppConstants.skipAuth] ?? false;

    if (err.response?.statusCode == 401 && !skipAuth) {
      _cacheService.clear();
      _secureStorageClient.deleteToken();
      _authNotifier.logout();
    }

    super.onError(err, handler);
  }
}
