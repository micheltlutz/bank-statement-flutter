import 'package:balance/balance/domain/entities/balance.dart';

class BalanceModel extends Balance {
  const BalanceModel({required super.amount});

  factory BalanceModel.fromJson(Map<String, dynamic> json) {
    return BalanceModel(
      amount: (json['amount'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
    };
  }

  Balance toEntity() {
    return Balance(amount: amount);
  }
}

