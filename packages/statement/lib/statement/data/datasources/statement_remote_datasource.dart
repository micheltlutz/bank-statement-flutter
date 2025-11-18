import 'package:core/core.dart';
import 'package:network/network.dart';

class StatementRemoteDataSource {
  StatementRemoteDataSource(this.httpClient);

  final HttpClientInterface httpClient;

  Future<List<Map<String, dynamic>>> getStatements({
    int skip = 0,
    int limit = 10,
  }) async {
    try {
      final response = await httpClient.get(
        ApiConstants.statementsEndpoint,
        queryParameters: {
          'skip': skip,
          'limit': limit,
        },
      );

      if (response.containsKey('items')) {
        final items = response['items'];
        if (items is List) {
          return List<Map<String, dynamic>>.from(items);
        }
      }
      return [];
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to get statements: ${e.toString()}', 500);
    }
  }

  Future<Map<String, dynamic>> getStatementById(int id) async {
    try {
      final response = await httpClient.get(
        '${ApiConstants.statementsEndpoint}$id',
      );
      return response;
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to get statement: ${e.toString()}', 500);
    }
  }
}

