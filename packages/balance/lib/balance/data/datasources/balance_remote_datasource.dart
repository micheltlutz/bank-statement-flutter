import 'package:core/core.dart';
import 'package:network/network.dart';

class BalanceRemoteDataSource {
  BalanceRemoteDataSource(this.httpClient);

  final HttpClientInterface httpClient;

  Future<Map<String, dynamic>> getBalance() async {
    try {
      final response = await httpClient.get(ApiConstants.balanceEndpoint);
      return response;
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to get balance: ${e.toString()}', 500);
    }
  }
}

