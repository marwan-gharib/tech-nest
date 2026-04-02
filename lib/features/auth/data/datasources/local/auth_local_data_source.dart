import 'package:tech_nest/core/error/exceptions/exceptions.dart';
import 'package:tech_nest/core/local/secure/secure_storage_client.dart';

class AuthLocalDatasource {
  final SecureStorageClient _secureStorage;

  AuthLocalDatasource(this._secureStorage);

  Future<void> saveToken(String token) async {
    try {
      await _secureStorage.saveToken(token);
    } catch (e) {
      throw UnKnownException();
    }
  }

  Future<String?> getToken() async {
    try {
      return await _secureStorage.getToken();
    } catch (e) {
      throw UnKnownException();
    }
  }

  Future<void> clearCache() async {
    try {
      await _secureStorage.deleteToken();
    } catch (e) {
      throw UnKnownException();
    }
  }
}
