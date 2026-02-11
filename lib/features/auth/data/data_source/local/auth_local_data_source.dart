import 'package:tech_nest/core/constants/api_keys.dart';
import 'package:tech_nest/core/services/local/cache/cache_service.dart';

class AuthLocalDataSource {
  final CacheService _cache;

  AuthLocalDataSource(this._cache);

  Future<void> saveToken(String token) async {
    await _cache.setData(key: ApiKeys.token, value: token);
  }

  void getToken() {
    _cache.get(ApiKeys.token);
  }

  Future<void> clearCache() async {
    await _cache.clear();
  }
}
