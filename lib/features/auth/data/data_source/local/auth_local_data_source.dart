import 'package:tech_nest/core/constants/api_keys.dart';
import 'package:tech_nest/core/error/exceptions/exceptions.dart';
import 'package:tech_nest/core/services/local/cache/cache_service.dart';

class AuthLocalDataSource {
  final CacheService _cache;

  AuthLocalDataSource(this._cache);

  Future<void> saveToken(String token) async {
    try {
      await _cache.setData(key: ApiKeys.token, value: token);
    } on CacheException {
      rethrow;
    } catch (e) {
      throw UnKnownException();
    }
  }

  void getToken() {
    try {
      _cache.get(ApiKeys.token);
    } on CacheException {
      rethrow;
    } catch (e) {
      throw UnKnownException();
    }
  }

  Future<void> clearCache() async {
    try {
      await _cache.clear();
    } on CacheException {
      rethrow;
    } catch (e) {
      throw UnKnownException();
    }
  }
}
