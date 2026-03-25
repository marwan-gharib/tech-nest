import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tech_nest/core/constants/api_keys.dart';
import 'package:tech_nest/core/error/exceptions/exceptions.dart';
import 'secure_storage_service.dart';

class SecureStorageServiceImpl implements SecureStorageService {
  final FlutterSecureStorage _storage;

  SecureStorageServiceImpl(this._storage);

  @override
  Future<void> saveToken(String token) async {
    try {
      await _storage.write(key: ApiKeys.token, value: token);
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<String?> getToken() async {
    try {
      return await _storage.read(key: ApiKeys.token);
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> deleteToken() async {
    try {
      await _storage.delete(key: ApiKeys.token);
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<bool> hasToken() async {
    try {
      return await _storage.containsKey(key: ApiKeys.token);
    } catch (e) {
      // Graceful fallback for corrupted keystore exceptions on app startup
      return false;
    }
  }
}
