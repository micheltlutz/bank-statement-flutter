import 'package:equatable/equatable.dart';
import 'package:statement/statement/domain/entities/statement.dart';

abstract class StatementState extends Equatable {
  const StatementState();

  @override
  List<Object?> get props => [];
}

class StatementInitial extends StatementState {
  const StatementInitial();
}

class StatementLoading extends StatementState {
  const StatementLoading();
}

class StatementLoaded extends StatementState {
  const StatementLoaded({
    required this.statements,
    this.hasMore = true,
    this.isLoadingMore = false,
  });

  final List<Statement> statements;
  final bool hasMore;
  final bool isLoadingMore;

  @override
  List<Object?> get props => [statements, hasMore, isLoadingMore];
}

class StatementError extends StatementState {
  const StatementError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class StatementDetailLoading extends StatementState {
  const StatementDetailLoading();
}

class StatementDetailLoaded extends StatementState {
  const StatementDetailLoaded(this.statement);

  final Statement statement;

  @override
  List<Object?> get props => [statement];
}

class StatementDetailError extends StatementState {
  const StatementDetailError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

