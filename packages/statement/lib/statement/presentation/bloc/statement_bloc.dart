import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import 'package:statement/statement/domain/entities/statement.dart';
import 'package:statement/statement/domain/usecases/get_statements_usecase.dart';
import 'package:statement/statement/domain/usecases/get_statement_detail_usecase.dart';
import 'package:statement/statement/presentation/bloc/statement_event.dart';
import 'package:statement/statement/presentation/bloc/statement_state.dart';

class StatementBloc extends Bloc<StatementEvent, StatementState> {
  StatementBloc({
    required this.getStatementsUseCase,
    required this.getStatementDetailUseCase,
  }) : super(const StatementInitial()) {
    on<LoadStatementsEvent>(_onLoadStatements);
    on<LoadMoreStatementsEvent>(_onLoadMoreStatements);
    on<LoadStatementDetailEvent>(_onLoadStatementDetail);
    on<SearchStatementsEvent>(_onSearchStatements);
  }

  final GetStatementsUseCase getStatementsUseCase;
  final GetStatementDetailUseCase getStatementDetailUseCase;

  int _currentSkip = 0;
  static const int _pageSize = 10;
  List<Statement> _allStatements = [];

  Future<void> _onLoadStatements(
    LoadStatementsEvent event,
    Emitter<StatementState> emit,
  ) async {
    if (event.refresh) {
      _currentSkip = 0;
      _allStatements = [];
    }

    emit(const StatementLoading());

    try {
      final statements = await getStatementsUseCase(
        skip: _currentSkip,
        limit: _pageSize,
      );

      if (event.refresh) {
        _allStatements = statements;
      } else {
        _allStatements.addAll(statements);
      }

      _currentSkip += statements.length;

      emit(StatementLoaded(
        statements: List.from(_allStatements),
        hasMore: statements.length == _pageSize,
      ));
    } on AppException catch (e) {
      emit(StatementError(e.message));
    } catch (e) {
      emit(StatementError('Failed to load statements: ${e.toString()}'));
    }
  }

  Future<void> _onLoadMoreStatements(
    LoadMoreStatementsEvent event,
    Emitter<StatementState> emit,
  ) async {
    final currentState = state;
    if (currentState is StatementLoaded && currentState.isLoadingMore) {
      return;
    }

    if (currentState is StatementLoaded) {
      emit(currentState.copyWith(isLoadingMore: true));
    }

    try {
      final statements = await getStatementsUseCase(
        skip: _currentSkip,
        limit: _pageSize,
      );

      _allStatements.addAll(statements);
      _currentSkip += statements.length;

      emit(StatementLoaded(
        statements: List.from(_allStatements),
        hasMore: statements.length == _pageSize,
        isLoadingMore: false,
      ));
    } on AppException catch (e) {
      emit(StatementError(e.message));
    } catch (e) {
      emit(StatementError('Failed to load more statements: ${e.toString()}'));
    }
  }

  Future<void> _onLoadStatementDetail(
    LoadStatementDetailEvent event,
    Emitter<StatementState> emit,
  ) async {
    emit(const StatementDetailLoading());

    try {
      final statement = await getStatementDetailUseCase(event.statementId);
      emit(StatementDetailLoaded(statement));
    } on AppException catch (e) {
      emit(StatementDetailError(e.message));
    } catch (e) {
      emit(StatementDetailError('Failed to load statement: ${e.toString()}'));
    }
  }

  Future<void> _onSearchStatements(
    SearchStatementsEvent event,
    Emitter<StatementState> emit,
  ) async {
    if (event.query.isEmpty) {
      add(const LoadStatementsEvent(refresh: true));
      return;
    }

    final currentState = state;
    if (currentState is StatementLoaded) {
      final filtered = _allStatements
          .where((s) => s.description.toLowerCase().contains(event.query.toLowerCase()))
          .toList();
      
      emit(currentState.copyWith(statements: filtered));
    }
  }
}

extension StatementLoadedExtension on StatementLoaded {
  StatementLoaded copyWith({
    List<Statement>? statements,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return StatementLoaded(
      statements: statements ?? this.statements,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

