import 'package:core/core.dart';
import 'package:statement/statement/domain/entities/statement.dart';
import 'package:statement/statement/domain/repositories/statement_repository.dart';

class GetStatementDetailUseCase {
  GetStatementDetailUseCase(this.repository);

  final StatementRepository repository;

  Future<Statement> call(int id) async {
    try {
      return await repository.getStatementById(id);
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to get statement detail: ${e.toString()}', 500);
    }
  }
}

