part of 'hall_cubit.dart';

sealed class HallState extends Equatable {
  const HallState();

  @override
  List<Object?> get props => [];
}

final class HallInitial extends HallState {
  const HallInitial();
}

final class HallLoading extends HallState {
  const HallLoading();
}

final class HallSuccess extends HallState {
  final List<HallTableEntity> tables;
  final HallSortOption sort;

  const HallSuccess(this.tables, {this.sort = HallSortOption.numberAsc});

  @override
  List<Object?> get props => [tables, sort];
}

final class HallError extends HallState {
  final String message;
  const HallError(this.message);

  @override
  List<Object?> get props => [message];
}
