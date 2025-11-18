import 'package:core/core.dart';
import 'package:balance/balance/domain/entities/balance.dart';
import 'package:balance/balance/domain/repositories/balance_repository.dart';
import 'package:balance/balance/data/datasources/balance_remote_datasource.dart';
import 'package:balance/balance/data/models/balance_model.dart';

class BalanceRepositoryImpl implements BalanceRepository {
  BalanceRepositoryImpl(this.remoteDataSource);

  final BalanceRemoteDataSource remoteDataSource;

  @override
  Future<Balance> getBalance() async {
    try {
      final response = await remoteDataSource.getBalance();
      final balanceModel = BalanceModel.fromJson(response);
      return balanceModel.toEntity();
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to get balance: ${e.toString()}', 500);
    }
  }
}

