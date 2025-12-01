import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class LoginEvent extends AuthEvent {
  const LoginEvent({
    required this.userId,
    required this.password,
  });

  final String userId;
  final String password;

  @override
  List<Object?> get props => [userId, password];
}

class CreateUserEvent extends AuthEvent {
  const CreateUserEvent({
    required this.userId,
    required this.password,
    required this.fullName,
    required this.birthDate,
  });

  final String userId;
  final String password;
  final String fullName;
  final DateTime birthDate;

  @override
  List<Object?> get props => [userId, password, fullName, birthDate];
}

class LogoutEvent extends AuthEvent {
  const LogoutEvent();
}

class CheckAuthStatusEvent extends AuthEvent {
  const CheckAuthStatusEvent();
}

