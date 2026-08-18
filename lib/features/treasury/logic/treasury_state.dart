part of 'treasury_cubit.dart';

sealed class TreasuryState extends Equatable {
  const TreasuryState();

  @override
  List<Object?> get props => [];
}

final class TreasuryInitial extends TreasuryState {
  const TreasuryInitial();
}

final class TreasuryLoading extends TreasuryState {
  const TreasuryLoading();
}

final class TreasurySuccess extends TreasuryState {
  final List<TreasuryTransactionEntity> transactions;
  final double totalIncome;
  final double totalExpense;

  final double openingBalance;

  const TreasurySuccess({
    required this.transactions,
    required this.totalIncome,
    required this.totalExpense,
    this.openingBalance = 0,
  });

  double get balance => openingBalance + totalIncome - totalExpense;

  @override
  List<Object?> get props =>
      [transactions, totalIncome, totalExpense, openingBalance];
}

final class TreasuryError extends TreasuryState {
  final String message;

  const TreasuryError(this.message);

  @override
  List<Object?> get props => [message];
}
