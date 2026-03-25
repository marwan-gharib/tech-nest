import 'package:dio/dio.dart';
import 'package:tech_nest/core/constants/api_keys.dart';
import 'package:tech_nest/core/services/local/cache/cache_service.dart';

class AuthInterceptor extends Interceptor {
  final CacheService _cacheService;

  AuthInterceptor(this._cacheService);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers[ApiKeys.token] = _cacheService.get(ApiKeys.token);
    super.onRequest(options, handler);
  }
}
