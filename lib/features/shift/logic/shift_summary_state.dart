part of 'shift_summary_cubit.dart';

sealed class ShiftSummaryState extends Equatable {
  const ShiftSummaryState();

  @override
  List<Object?> get props => [];
}

final class ShiftSummaryInitial extends ShiftSummaryState {
  const ShiftSummaryInitial();
}

final class ShiftSummaryLoading extends ShiftSummaryState {
  const ShiftSummaryLoading();
}

final class ShiftSummarySuccess extends ShiftSummaryState {
  final ShiftSummary summary;

  const ShiftSummarySuccess(this.summary);

  @override
  List<Object?> get props => [summary];
}

final class ShiftSummaryError extends ShiftSummaryState {
  final String message;

  const ShiftSummaryError(this.message);

  @override
  List<Object?> get props => [message];
}
