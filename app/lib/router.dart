import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';
import 'package:auth/auth.dart';
import 'package:auth/auth/data/datasources/auth_local_datasource.dart';
import 'package:auth/auth/data/datasources/auth_remote_datasource.dart';
import 'package:auth/auth/data/repositories/auth_repository_impl.dart';
import 'package:auth/auth/domain/usecases/login_usecase.dart';
import 'package:auth/auth/domain/usecases/create_user_usecase.dart';
import 'package:auth/auth/domain/usecases/logout_usecase.dart';
import 'package:network/network.dart';
import 'package:statement/statement.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) {
          return _buildAuthPage(context);
        },
      ),
      GoRoute(
        path: '/statements',
        builder: (context, state) {
          return _buildStatementListPage(context);
        },
      ),
      GoRoute(
        path: '/statement/:id',
        builder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
          return _buildStatementDetailPage(context, id);
        },
      ),
    ],
  );

  static Widget _buildAuthPage(BuildContext context) {
    // Initialize dependencies
    final authStorage = AuthLocalDataSource();
    final httpClient = HttpClient(
      baseUrl: ApiConstants.baseUrl,
      authStorage: authStorage,
    );

    final authRemoteDataSource = AuthRemoteDataSource(httpClient);
    final authRepository = AuthRepositoryImpl(
      remoteDataSource: authRemoteDataSource,
      localDataSource: authStorage,
    );

    final loginUseCase = LoginUseCase(authRepository);
    final createUserUseCase = CreateUserUseCase(authRepository);
    final logoutUseCase = LogoutUseCase(authRepository);

    final authBloc = AuthBloc(
      loginUseCase: loginUseCase,
      createUserUseCase: createUserUseCase,
      logoutUseCase: logoutUseCase,
    );

    // Check if user is already authenticated
    authRepository.isAuthenticated().then((isAuthenticated) {
      if (isAuthenticated) {
        // User is already authenticated, navigate to statements
        Future.microtask(() => router.go('/statements'));
      } else {
        // User is not authenticated, emit unauthenticated state
        authBloc.add(const CheckAuthStatusEvent());
      }
    });

    return BlocProvider.value(
      value: authBloc,
      child: BlocListener<AuthBloc, AuthState>(
        bloc: authBloc,
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            // Navigate to statements page after successful login
            router.go('/statements');
          }
        },
        child: LoginPage(
          bloc: authBloc,
          onLoginSuccess: () {
            // Navigation is handled by BlocListener
          },
        ),
      ),
    );
  }

  static Widget _buildStatementListPage(BuildContext context) {
    // Initialize dependencies
    final authStorage = AuthLocalDataSource();
    final httpClient = HttpClient(
      baseUrl: ApiConstants.baseUrl,
      authStorage: authStorage,
    );

    final statementRemoteDataSource = StatementRemoteDataSource(httpClient);
    final statementRepository = StatementRepositoryImpl(statementRemoteDataSource);

    final statementBloc = StatementBloc(
      getStatementsUseCase: GetStatementsUseCase(statementRepository),
      getStatementDetailUseCase: GetStatementDetailUseCase(statementRepository),
    );

    return StatementListPage(
      bloc: statementBloc,
      onStatementTap: (id) {
        router.go('/statement/$id');
      },
    );
  }

  static Widget _buildStatementDetailPage(BuildContext context, int id) {
    final authStorage = AuthLocalDataSource();
    final httpClient = HttpClient(
      baseUrl: ApiConstants.baseUrl,
      authStorage: authStorage,
    );

    final statementRemoteDataSource = StatementRemoteDataSource(httpClient);
    final statementRepository = StatementRepositoryImpl(statementRemoteDataSource);

    final statementBloc = StatementBloc(
      getStatementsUseCase: GetStatementsUseCase(statementRepository),
      getStatementDetailUseCase: GetStatementDetailUseCase(statementRepository),
    );

    return StatementDetailPage(
      bloc: statementBloc,
      statementId: id,
    );
  }
}
