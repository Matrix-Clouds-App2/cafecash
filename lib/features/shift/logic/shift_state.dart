part of 'shift_cubit.dart';

sealed class ShiftState extends Equatable {
  const ShiftState();

  @override
  List<Object?> get props => [];
}

final class ShiftInitial extends ShiftState {
  const ShiftInitial();
}

final class ShiftLoading extends ShiftState {
  const ShiftLoading();
}

final class ShiftReady extends ShiftState {
  final ShiftEntity? active;

  final List<ShiftEntity> history;

  const ShiftReady({required this.active, required this.history});

  @override
  List<Object?> get props => [active, history];
}

final class ShiftError extends ShiftState {
  final String message;

  const ShiftError(this.message);

  @override
  List<Object?> get props => [message];
}
