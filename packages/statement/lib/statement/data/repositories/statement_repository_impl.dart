import 'package:core/core.dart';
import 'package:statement/statement/domain/entities/statement.dart';
import 'package:statement/statement/domain/repositories/statement_repository.dart';
import 'package:statement/statement/data/datasources/statement_remote_datasource.dart';
import 'package:statement/statement/data/models/statement_model.dart';

class StatementRepositoryImpl implements StatementRepository {
  StatementRepositoryImpl(this.remoteDataSource);

  final StatementRemoteDataSource remoteDataSource;

  @override
  Future<List<Statement>> getStatements({
    int skip = 0,
    int limit = 10,
  }) async {
    try {
      final response = await remoteDataSource.getStatements(
        skip: skip,
        limit: limit,
      );
      
      return response
          .map((json) => StatementModel.fromJson(json))
          .map((model) => model.toEntity())
          .toList();
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to get statements: ${e.toString()}', 500);
    }
  }

  @override
  Future<Statement> getStatementById(int id) async {
    try {
      final response = await remoteDataSource.getStatementById(id);
      final model = StatementModel.fromJson(response);
      return model.toEntity();
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to get statement: ${e.toString()}', 500);
    }
  }
}

