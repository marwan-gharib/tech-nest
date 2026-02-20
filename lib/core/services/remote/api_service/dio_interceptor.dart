import 'package:dio/dio.dart';
import 'package:tech_nest/core/constants/api_keys.dart';
import 'package:tech_nest/core/constants/app_consts.dart';
import 'package:tech_nest/core/services/local/cache/cache_service.dart';
import 'package:tech_nest/core/utils/auth/auth_notifire.dart';

class DioInterceptor extends Interceptor {
  final CacheService _cacheService;
  final AuthNotifire _authNotifire;

  DioInterceptor(this._cacheService, this._authNotifire);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers["token"] = _cacheService.get(ApiKeys.token);
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final bool skipAuth = err.requestOptions.extra[AppConsts.skipAuth] == true
        ? true
        : false;

    if (err.response?.statusCode == 401 && !skipAuth) {
      // _cacheService.clear();
      _authNotifire.logout();
    }

    super.onError(err, handler);
  }
}
