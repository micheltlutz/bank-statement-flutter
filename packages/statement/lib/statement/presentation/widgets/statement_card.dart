import 'package:flutter/material.dart';
import 'package:statement/statement/domain/entities/statement.dart';
import 'package:statement/statement/presentation/widgets/transaction_item.dart';

class StatementCard extends StatelessWidget {
  const StatementCard({
    required this.statement,
    this.onTap,
    super.key,
  });

  final Statement statement;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TransactionItem(
        statement: statement,
        onTap: onTap,
      ),
    );
  }
}

