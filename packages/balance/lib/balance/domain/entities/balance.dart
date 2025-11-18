import 'package:equatable/equatable.dart';

class Balance extends Equatable {
  const Balance({required this.amount});

  final double amount;

  @override
  List<Object?> get props => [amount];
}

