import 'package:statement/statement/domain/entities/statement.dart';

abstract class StatementRepository {
  Future<List<Statement>> getStatements({
    int skip = 0,
    int limit = 10,
  });

  Future<Statement> getStatementById(int id);
}

