import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:statement/statement/presentation/bloc/statement_bloc.dart';
import 'package:statement/statement/presentation/bloc/statement_event.dart';
import 'package:statement/statement/presentation/bloc/statement_state.dart';

class StatementDetailPage extends StatelessWidget {
  const StatementDetailPage({
    required this.bloc,
    required this.statementId,
    super.key,
  });

  final StatementBloc bloc;
  final int statementId;

  @override
  Widget build(BuildContext context) {
    bloc.add(LoadStatementDetailEvent(statementId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statement Detail'),
      ),
      body: BlocBuilder<StatementBloc, StatementState>(
        bloc: bloc,
        builder: (context, state) {
          if (state is StatementDetailLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is StatementDetailError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      bloc.add(LoadStatementDetailEvent(statementId));
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is StatementDetailLoaded) {
            final statement = state.statement;
            final isCredit = statement.isCredit;
            final color = isCredit
                ? const Color(0xFF4CAF50)
                : const Color(0xFFF44336);

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                statement.description,
                                style:
                                    Theme.of(context).textTheme.displaySmall,
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: color.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  statement.type.toString().split('.').last,
                                  style: TextStyle(
                                    color: color,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            '${isCredit ? "+" : "-"}\$${statement.amount}',
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium
                                ?.copyWith(
                                  color: color,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Details',
                            style:
                                Theme.of(context).textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                          const SizedBox(height: 16),
                          _buildDetailRow(
                            context,
                            'Date',
                            DateFormat('MMM dd, yyyy HH:mm')
                                .format(statement.createdAt),
                          ),
                          if (statement.fromUser != null)
                            _buildDetailRow(
                              context,
                              'From',
                              statement.fromUser!,
                            ),
                          if (statement.toUser != null)
                            _buildDetailRow(
                              context,
                              'To',
                              statement.toUser!,
                            ),
                          if (statement.bankName != null)
                            _buildDetailRow(
                              context,
                              'Bank',
                              statement.bankName!,
                            ),
                          _buildDetailRow(
                            context,
                            'Transaction ID',
                            statement.id.toString(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white70,
                  ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }
}

