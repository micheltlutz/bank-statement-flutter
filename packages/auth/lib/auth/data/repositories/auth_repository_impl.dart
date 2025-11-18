import 'package:core/core.dart';
import 'package:auth/auth/domain/entities/user.dart';
import 'package:auth/auth/domain/repositories/auth_repository.dart';
import 'package:auth/auth/data/datasources/auth_local_datasource.dart';
import 'package:auth/auth/data/datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  @override
  Future<User> login(String userId, String password) async {
    try {
      final response = await remoteDataSource.login(userId, password);
      
      final token = response['access_token'] as String? ?? '';
      final tokenType = response['token_type'] as String? ?? 'Bearer';
      
      // Save token securely
      if (token.isNotEmpty) {
        await localDataSource.saveToken(token);
      }
      
      return User(
        userId: userId,
        fullName: userId, // API doesn't return fullname on login
        token: token,
        tokenType: tokenType,
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw AuthenticationException('Login failed: ${e.toString()}');
    }
  }

  @override
  Future<void> logout() async {
    await localDataSource.deleteToken();
  }

  @override
  Future<String?> getToken() async {
    return await localDataSource.getToken();
  }

  @override
  Future<bool> isAuthenticated() async {
    final token = await localDataSource.getToken();
    return token != null && token.isNotEmpty;
  }
}

