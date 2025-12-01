import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import 'package:auth/auth/domain/usecases/login_usecase.dart';
import 'package:auth/auth/domain/usecases/create_user_usecase.dart';
import 'package:auth/auth/domain/usecases/logout_usecase.dart';
import 'package:auth/auth/presentation/bloc/auth_event.dart';
import 'package:auth/auth/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required this.loginUseCase,
    required this.createUserUseCase,
    required this.logoutUseCase,
  }) : super(const AuthInitial()) {
    on<LoginEvent>(_onLogin);
    on<CreateUserEvent>(_onCreateUser);
    on<LogoutEvent>(_onLogout);
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
  }

  final LoginUseCase loginUseCase;
  final CreateUserUseCase createUserUseCase;
  final LogoutUseCase logoutUseCase;

  Future<void> _onLogin(
    LoginEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      final user = await loginUseCase(event.userId, event.password);
      emit(AuthAuthenticated(user));
    } on AuthenticationException catch (e) {
      emit(AuthError(e.message));
    } catch (e) {
      emit(AuthError('Erro ao fazer login: ${e.toString()}'));
    }
  }

  Future<void> _onCreateUser(
    CreateUserEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      await createUserUseCase(
        userId: event.userId,
        password: event.password,
        fullName: event.fullName,
        birthDate: event.birthDate,
      );
      emit(const UserCreatedSuccess());
    } on AuthenticationException catch (e) {
      emit(AuthError(e.message));
    } catch (e) {
      emit(AuthError('Erro ao criar usuário: ${e.toString()}'));
    }
  }

  Future<void> _onLogout(
    LogoutEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      await logoutUseCase();
      emit(const AuthUnauthenticated());
    } catch (e) {
      emit(AuthError('Erro ao fazer logout: ${e.toString()}'));
    }
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    // This would typically check if there's a valid token
    // For now, we'll just emit unauthenticated
    emit(const AuthUnauthenticated());
  }
}

