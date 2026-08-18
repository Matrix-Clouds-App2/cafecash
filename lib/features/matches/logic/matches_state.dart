part of 'matches_cubit.dart';

sealed class MatchesState extends Equatable {
  const MatchesState();

  @override
  List<Object?> get props => [];
}

final class MatchesInitial extends MatchesState {
  const MatchesInitial();
}

final class MatchesLoading extends MatchesState {
  const MatchesLoading();
}

final class MatchesSuccess extends MatchesState {
  final List<MatchSeatEntity> seats;
  final MatchesSortOption sort;

  const MatchesSuccess(this.seats, {this.sort = MatchesSortOption.numberAsc});

  @override
  List<Object?> get props => [seats, sort];
}

final class MatchesError extends MatchesState {
  final String message;
  const MatchesError(this.message);

  @override
  List<Object?> get props => [message];
}
