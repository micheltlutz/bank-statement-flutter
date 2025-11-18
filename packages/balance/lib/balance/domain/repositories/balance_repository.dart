import 'package:core/core.dart';
import 'package:balance/balance/domain/entities/balance.dart';

abstract class BalanceRepository {
  Future<Balance> getBalance();
}

