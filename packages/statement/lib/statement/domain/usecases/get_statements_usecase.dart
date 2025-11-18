import 'package:core/core.dart';
import 'package:statement/statement/domain/entities/statement.dart';
import 'package:statement/statement/domain/repositories/statement_repository.dart';

class GetStatementsUseCase {
  GetStatementsUseCase(this.repository);

  final StatementRepository repository;

  Future<List<Statement>> call({
    int skip = 0,
    int limit = 10,
  }) async {
    try {
      return await repository.getStatements(skip: skip, limit: limit);
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to get statements: ${e.toString()}', 500);
    }
  }
}

