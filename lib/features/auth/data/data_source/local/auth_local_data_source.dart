import 'package:tech_nest/core/error/exceptions/exceptions.dart';
import 'package:tech_nest/core/services/local/secure/secure_storage_service.dart';

class AuthLocalDataSource {
  final SecureStorageService _secureStorage;

  AuthLocalDataSource(this._secureStorage);

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
