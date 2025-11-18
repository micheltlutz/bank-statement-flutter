import 'package:equatable/equatable.dart';

enum StatementType {
  deposit,
  withdrawal,
  transfer,
}

class Statement extends Equatable {
  const Statement({
    required this.id,
    required this.description,
    required this.type,
    required this.createdAt,
    required this.amount,
    this.toUser,
    this.fromUser,
    this.bankName,
  });

  final int id;
  final String description;
  final StatementType type;
  final DateTime createdAt;
  final String amount;
  final String? toUser;
  final String? fromUser;
  final String? bankName;

  bool get isCredit => type == StatementType.deposit;
  bool get isDebit => type == StatementType.withdrawal || type == StatementType.transfer;

  @override
  List<Object?> get props => [
        id,
        description,
        type,
        createdAt,
        amount,
        toUser,
        fromUser,
        bankName,
      ];
}

