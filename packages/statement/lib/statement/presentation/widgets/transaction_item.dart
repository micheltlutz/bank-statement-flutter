import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:core/core.dart';
import 'package:statement/statement/domain/entities/statement.dart';

class TransactionItem extends StatelessWidget {
  const TransactionItem({
    required this.statement,
    this.onTap,
    super.key,
  });

  final Statement statement;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isCredit = statement.isCredit;
    final color = isCredit ? AppTheme.successColor : AppTheme.errorColor;
    final icon = isCredit ? Icons.arrow_upward : Icons.arrow_downward;
    final amountPrefix = isCredit ? '+' : '-';

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    statement.description,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  Text(
                    DateFormat('MMM dd, yyyy').format(statement.createdAt),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Text(
              '$amountPrefix\$${statement.amount}',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

