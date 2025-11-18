import 'package:core/core.dart';
import 'package:auth/auth/domain/entities/user.dart';
import 'package:auth/auth/domain/repositories/auth_repository.dart';

class LoginUseCase {
  LoginUseCase(this.repository);

  final AuthRepository repository;

  Future<User> call(String userId, String password) async {
    try {
      return await repository.login(userId, password);
    } on AppException {
      rethrow;
    } catch (e) {
      throw AuthenticationException('Login failed: ${e.toString()}');
    }
  }
}

