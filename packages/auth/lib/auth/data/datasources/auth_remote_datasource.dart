import 'package:core/core.dart';
import 'package:network/network.dart';

class AuthRemoteDataSource {
  AuthRemoteDataSource(this.httpClient);

  final HttpClientInterface httpClient;

  Future<Map<String, dynamic>> login(String userId, String password) async {
    try {
      final response = await httpClient.post(
        ApiConstants.authEndpoint,
        data: {
          'userid': userId,
          'password': password,
        },
      );

      if (response.containsKey('access_token')) {
        return response;
      } else {
        throw AuthenticationException('Invalid response from server');
      }
    } on AppException {
      rethrow;
    } catch (e) {
      throw AuthenticationException('Login failed: ${e.toString()}');
    }
  }

  Future<void> createUser({
    required String userId,
    required String password,
    required String fullName,
    required DateTime birthDate,
  }) async {
    try {
      await httpClient.post(
        '/users/',
        data: {
          'userid': userId,
          'password': password,
          'fullname': fullName,
          'birthdate': birthDate.toIso8601String().split('T')[0], // Format as YYYY-MM-DD
        },
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw AuthenticationException('Failed to create user: ${e.toString()}');
    }
  }
}

