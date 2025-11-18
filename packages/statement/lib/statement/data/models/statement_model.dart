import 'package:statement/statement/domain/entities/statement.dart';

class StatementModel extends Statement {
  const StatementModel({
    required super.id,
    required super.description,
    required super.type,
    required super.createdAt,
    required super.amount,
    super.toUser,
    super.fromUser,
    super.bankName,
  });

  factory StatementModel.fromJson(Map<String, dynamic> json) {
    StatementType type;
    final typeString = (json['type'] as String? ?? '').toLowerCase();
    
    switch (typeString) {
      case 'deposit':
        type = StatementType.deposit;
        break;
      case 'withdrawal':
        type = StatementType.withdrawal;
        break;
      case 'transfer':
        type = StatementType.transfer;
        break;
      default:
        type = StatementType.deposit;
    }

    return StatementModel(
      id: json['id'] as int,
      description: json['description'] as String? ?? '',
      type: type,
      createdAt: DateTime.parse(json['created_at'] as String),
      amount: json['amount'] as String? ?? '0',
      toUser: json['to_user'] as String?,
      fromUser: json['from_user'] as String?,
      bankName: json['bank_name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    String typeString;
    switch (type) {
      case StatementType.deposit:
        typeString = 'Deposit';
        break;
      case StatementType.withdrawal:
        typeString = 'Withdrawal';
        break;
      case StatementType.transfer:
        typeString = 'Transfer';
        break;
    }

    return {
      'id': id,
      'description': description,
      'type': typeString,
      'created_at': createdAt.toIso8601String(),
      'amount': amount,
      'to_user': toUser,
      'from_user': fromUser,
      'bank_name': bankName,
    };
  }

  Statement toEntity() {
    return Statement(
      id: id,
      description: description,
      type: type,
      createdAt: createdAt,
      amount: amount,
      toUser: toUser,
      fromUser: fromUser,
      bankName: bankName,
    );
  }
}

