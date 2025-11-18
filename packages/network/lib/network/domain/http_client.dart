import 'package:core/core.dart';
import 'package:dio/dio.dart';
import 'package:network/network/data/datasources/api_client.dart';
import 'package:network/network/data/interceptors/auth_interceptor.dart';

class HttpClient implements HttpClientInterface {
  HttpClient({
    required String baseUrl,
    AuthStorageInterface? authStorage,
  }) : _dio = Dio(
          BaseOptions(
            baseUrl: baseUrl,
            connectTimeout: const Duration(seconds: 30),
            receiveTimeout: const Duration(seconds: 30),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        ) {
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));

    if (authStorage != null) {
      _dio.interceptors.add(AuthInterceptor(authStorage: authStorage));
    }
  }

  final Dio _dio;

  @override
  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        path,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return response.data ?? {};
    } on DioException catch (e) {
      _handleDioException(e);
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return response.data ?? {};
    } on DioException catch (e) {
      _handleDioException(e);
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _dio.put<Map<String, dynamic>>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return response.data ?? {};
    } on DioException catch (e) {
      _handleDioException(e);
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> delete(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _dio.delete<Map<String, dynamic>>(
        path,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return response.data ?? {};
    } on DioException catch (e) {
      _handleDioException(e);
      rethrow;
    }
  }

  void _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        throw NetworkException('Connection timeout');
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode ?? 0;
        final message = e.response?.data?['message'] ?? 'Server error';
        switch (statusCode) {
          case 401:
            throw AuthenticationException(message);
          case 403:
            throw AuthorizationException(message);
          case 404:
            throw NotFoundException(message);
          default:
            throw ServerException(message, statusCode);
        }
      case DioExceptionType.cancel:
        throw NetworkException('Request cancelled');
      case DioExceptionType.unknown:
        throw NetworkException('Network error: ${e.message}');
      default:
        throw NetworkException('Unknown error: ${e.message}');
    }
  }
}

