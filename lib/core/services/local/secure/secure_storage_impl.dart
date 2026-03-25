import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tech_nest/core/constants/api_keys.dart';
import 'secure_storage_service.dart';

class SecureStorageServiceImpl implements SecureStorageService {
  final FlutterSecureStorage _storage;

  SecureStorageServiceImpl(this._storage);

  @override
  Future<void> saveToken(String token) async {
    await _storage.write(key: ApiKeys.token, value: token);
  }

  @override
  Future<String?> getToken() async {
    return await _storage.read(key: ApiKeys.token);
  }

  @override
  Future<void> deleteToken() async {
    await _storage.delete(key: ApiKeys.token);
  }

  @override
  Future<bool> hasToken() async {
    return await _storage.containsKey(key: ApiKeys.token);
  }
}
