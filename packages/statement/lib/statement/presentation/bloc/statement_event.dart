import 'package:equatable/equatable.dart';

abstract class StatementEvent extends Equatable {
  const StatementEvent();

  @override
  List<Object?> get props => [];
}

class LoadStatementsEvent extends StatementEvent {
  const LoadStatementsEvent({this.refresh = false});

  final bool refresh;

  @override
  List<Object?> get props => [refresh];
}

class LoadMoreStatementsEvent extends StatementEvent {
  const LoadMoreStatementsEvent();
}

class LoadStatementDetailEvent extends StatementEvent {
  const LoadStatementDetailEvent(this.statementId);

  final int statementId;

  @override
  List<Object?> get props => [statementId];
}

class SearchStatementsEvent extends StatementEvent {
  const SearchStatementsEvent(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

