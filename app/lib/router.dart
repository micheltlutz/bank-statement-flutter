import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';
import 'package:auth/auth/data/datasources/auth_local_datasource.dart';
import 'package:network/network.dart';
import 'package:statement/statement.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
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
