import 'package:equatable/equatable.dart';

abstract class AppException extends Equatable implements Exception {
  const AppException(this.message, this.statusCode);

  final String message;
  final int statusCode;

  @override
  List<Object?> get props => [message, statusCode];
}

class ServerException extends AppException {
  const ServerException(super.message, super.statusCode);
}

class NetworkException extends AppException {
  const NetworkException(String message) : super(message, 0);
}

class CacheException extends AppException {
  const CacheException(String message) : super(message, 0);
}

class AuthenticationException extends AppException {
  const AuthenticationException(String message) : super(message, 401);
}

class AuthorizationException extends AppException {
  const AuthorizationException(String message) : super(message, 403);
}

class NotFoundException extends AppException {
  const NotFoundException(String message) : super(message, 404);
}

