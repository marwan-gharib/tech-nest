import 'package:tech_nest/core/local/secure/secure_storage_client.dart';

class FakeSecureStorage implements SecureStorageClient {
  String? _token;

  void reset() => _token = null;

  @override
  Future<void> deleteToken() async => _token = null;

  @override
  Future<String?> getToken() async => _token;

  @override
  Future<bool> hasToken() async => _token != null;

  @override
  Future<void> saveToken(String token) async => _token = token;
}
