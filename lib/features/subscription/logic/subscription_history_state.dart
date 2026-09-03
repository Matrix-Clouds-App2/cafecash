part of 'subscription_history_cubit.dart';

sealed class SubscriptionHistoryState extends Equatable {
  const SubscriptionHistoryState();

  @override
  List<Object?> get props => [];
}

final class SubscriptionHistoryInitial extends SubscriptionHistoryState {
  const SubscriptionHistoryInitial();
}

final class SubscriptionHistoryLoading extends SubscriptionHistoryState {
  const SubscriptionHistoryLoading();
}

final class SubscriptionHistoryLoaded extends SubscriptionHistoryState {
  final List<SubscriptionModel> entries;

  const SubscriptionHistoryLoaded(this.entries);

  @override
  List<Object?> get props => [entries];
}

final class SubscriptionHistoryError extends SubscriptionHistoryState {
  final String message;

  const SubscriptionHistoryError(this.message);

  @override
  List<Object?> get props => [message];
}
