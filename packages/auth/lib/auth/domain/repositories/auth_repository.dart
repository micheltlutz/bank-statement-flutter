import 'package:core/core.dart';
import 'package:auth/auth/domain/entities/user.dart';

abstract class AuthRepository {
  Future<User> login(String userId, String password);
  Future<void> logout();
  Future<String?> getToken();
  Future<bool> isAuthenticated();
}

