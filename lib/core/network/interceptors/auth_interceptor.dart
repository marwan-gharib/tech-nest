import 'package:dio/dio.dart';
import 'package:tech_nest/core/constants/api_keys.dart';
import 'package:tech_nest/core/local/secure/secure_storage_client.dart';

class AuthInterceptor extends Interceptor {
  final SecureStorageClient _secureStorage;

  AuthInterceptor(this._secureStorage);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _secureStorage.getToken();
    if (token != null) {
      options.headers[ApiKeys.token] = token;
    }
    handler.next(options);
  }
}
