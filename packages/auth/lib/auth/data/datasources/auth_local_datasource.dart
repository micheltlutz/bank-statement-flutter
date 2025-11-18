import 'package:core/core.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthLocalDataSource implements AuthStorageInterface {
  AuthLocalDataSource() : _storage = const FlutterSecureStorage();

  final FlutterSecureStorage _storage;
  static const String _tokenKey = 'auth_token';

  @override
  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  @override
  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  @override
  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }

  @override
  Future<void> clear() async {
    await _storage.deleteAll();
  }
}

