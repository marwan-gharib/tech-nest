import 'package:dio/dio.dart';
import 'package:tech_nest/core/constants/app_consts.dart';
import 'package:tech_nest/core/services/auth/auth_notifier.dart';
import 'package:tech_nest/core/services/local/cache/cache_service.dart';

class ErrorInterceptor extends Interceptor {
  final CacheService _cacheService;
  final AuthNotifier _authNotifier;

  ErrorInterceptor(this._cacheService, this._authNotifier);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final bool skipAuth = err.requestOptions.extra[AppConsts.skipAuth] ?? false;

    if (err.response?.statusCode == 401 && !skipAuth) {
      _cacheService.clear();
      _authNotifier.logout();
    }
    
    // Pass the error to the DioErrorHandler to throw ServerException
    // Or we just forward the error so DioClient can catch it and handle it
    super.onError(err, handler);
  }
}
