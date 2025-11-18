import 'package:core/core.dart';
import 'package:balance/balance/domain/entities/balance.dart';
import 'package:balance/balance/domain/repositories/balance_repository.dart';

class GetBalanceUseCase {
  GetBalanceUseCase(this.repository);

  final BalanceRepository repository;

  Future<Balance> call() async {
    try {
      return await repository.getBalance();
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to get balance: ${e.toString()}', 500);
    }
  }
}

