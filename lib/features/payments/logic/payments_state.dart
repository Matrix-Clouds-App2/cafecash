part of 'payments_cubit.dart';

sealed class PaymentsState extends Equatable {
  const PaymentsState();

  @override
  List<Object?> get props => [];
}

final class PaymentsInitial extends PaymentsState {
  const PaymentsInitial();
}

final class PaymentsLoading extends PaymentsState {
  const PaymentsLoading();
}

final class PaymentsSuccess extends PaymentsState {
  final List<OrderEntity> orders;

  const PaymentsSuccess(this.orders);

  @override
  List<Object?> get props => [orders];
}

final class PaymentsError extends PaymentsState {
  final String message;

  const PaymentsError(this.message);

  @override
  List<Object?> get props => [message];
}
