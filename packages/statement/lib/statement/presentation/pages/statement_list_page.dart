import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:balance/balance.dart';
import 'package:core/core.dart';
import 'package:statement/statement/presentation/bloc/statement_bloc.dart';
import 'package:statement/statement/presentation/bloc/statement_event.dart';
import 'package:statement/statement/presentation/bloc/statement_state.dart';
import 'package:statement/statement/presentation/widgets/statement_card.dart';

class StatementListPage extends StatefulWidget {
  const StatementListPage({
    required this.bloc,
    this.onStatementTap,
    super.key,
  });

  final StatementBloc bloc;
  final Function(int statementId)? onStatementTap;

  @override
  State<StatementListPage> createState() => _StatementListPageState();
}

class _StatementListPageState extends State<StatementListPage> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();
  Balance? _balance;

  @override
  void initState() {
    super.initState();
    widget.bloc.add(const LoadStatementsEvent(refresh: true));
    _scrollController.addListener(_onScroll);
    _loadBalance();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      widget.bloc.add(const LoadMoreStatementsEvent());
    }
  }

  Future<void> _loadBalance() async {
    // Balance will be loaded via DI in the app layer
    // This is a placeholder for the balance card
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            _buildSearchBar(context),
            _buildBalanceCards(context),
            _buildStatementList(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Text(
            'Statement',
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const Spacer(),
          const CircleAvatar(
            radius: 20,
            backgroundColor: Colors.blue,
            child: Icon(Icons.person, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search something',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    widget.bloc.add(const SearchStatementsEvent(''));
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onChanged: (value) {
          widget.bloc.add(SearchStatementsEvent(value));
        },
      ),
    );
  }

  Widget _buildBalanceCards(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: Card(
              color: Colors.purple,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.account_balance_wallet,
                        color: Colors.white, size: 32),
                    const SizedBox(height: 12),
                    Text(
                      'Money',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white70,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _balance != null
                          ? '\$${_balance!.amount.toStringAsFixed(0)}'
                          : '\$0',
                      style: Theme.of(context)
                          .textTheme
                          .displaySmall
                          ?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Card(
              color: Colors.orange,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.phone_android,
                        color: Colors.white, size: 32),
                    const SizedBox(height: 12),
                    Text(
                      'Expenses',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white70,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\$1',
                      style: Theme.of(context)
                          .textTheme
                          .displaySmall
                          ?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatementList(BuildContext context) {
    return Expanded(
      child: BlocBuilder<StatementBloc, StatementState>(
        bloc: widget.bloc,
        builder: (context, state) {
          if (state is StatementLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is StatementError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      widget.bloc.add(const LoadStatementsEvent(refresh: true));
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is StatementLoaded) {
            if (state.statements.isEmpty) {
              return const Center(child: Text('No statements found'));
            }

            return RefreshIndicator(
              onRefresh: () async {
                widget.bloc.add(const LoadStatementsEvent(refresh: true));
              },
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Description',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                color: AppTheme.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        Text(
                          'Amount',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                color: AppTheme.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: state.statements.length +
                          (state.isLoadingMore ? 1 : 0) +
                          (state.hasMore && !state.isLoadingMore ? 0 : 0),
                      itemBuilder: (context, index) {
                        if (index < state.statements.length) {
                          final statement = state.statements[index];
                          return StatementCard(
                            statement: statement,
                            onTap: widget.onStatementTap != null
                                ? () => widget.onStatementTap!(statement.id)
                                : null,
                          );
                        } else if (state.isLoadingMore) {
                          return const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        return const SizedBox.shrink();
                      },
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
}

