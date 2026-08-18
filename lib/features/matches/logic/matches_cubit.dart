import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/matches_repo.dart';
import '../data/models/match_seat_entity.dart';

part 'matches_state.dart';

enum MatchesSortOption { numberAsc, numberDesc, priceAsc, priceDesc }

class MatchesCubit extends Cubit<MatchesState> {
  MatchesCubit(this._repo) : super(const MatchesInitial());

  final MatchesRepo _repo;
  StreamSubscription<List<MatchSeatEntity>>? _subscription;

  List<MatchSeatEntity> _all = [];
  String _query = '';
  MatchesSortOption _sort = MatchesSortOption.numberAsc;

  void fetchSeats() {
    emit(const MatchesLoading());
    _subscription?.cancel();
    _subscription = _repo.watchSeats().listen(
      (seats) {
        _all = seats;
        _emitFiltered();
      },
      onError: (Object e) => emit(MatchesError(e.toString())),
    );
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }

  void addSeat() {
    try {
      _repo.addSeat();
      _all = _repo.getSeats();
      _emitFiltered();
    } catch (e) {
      emit(MatchesError(e.toString()));
    }
  }

  void toggleStatus(MatchSeatEntity seat) {
    final next = seat.statusEnum == MatchSeatStatus.disabled
        ? MatchSeatStatus.available
        : MatchSeatStatus.disabled;
    _repo.setStatus(seat.id, next);
    _all = _repo.getSeats();
    _emitFiltered();
  }

  bool isLastSeat(MatchSeatEntity seat) {
    final maxNumber = _all
        .map((s) => s.number)
        .fold<int>(seat.number, (a, b) => a > b ? a : b);
    return seat.number >= maxNumber;
  }

  void deleteSeat(MatchSeatEntity seat) {
    if (isLastSeat(seat)) {
      _repo.deleteSeat(seat.id);
    } else {
      _repo.setStatus(seat.id, MatchSeatStatus.disabled);
    }
    _all = _repo.getSeats();
    _emitFiltered();
  }

  void search(String query) {
    _query = query;
    _emitFiltered();
  }

  void sort(MatchesSortOption option) {
    _sort = option;
    _emitFiltered();
  }

  void _emitFiltered() {
    final query = _query.trim().toLowerCase();
    var seats = _all.where((seat) {
      if (query.isEmpty) return true;
      return seat.number.toString().contains(query) ||
          seat.price.toStringAsFixed(0).contains(query) ||
          (seat.customerName ?? '').toLowerCase().contains(query);
    }).toList();

    seats.sort((a, b) {
      switch (_sort) {
        case MatchesSortOption.numberAsc:
          return a.number.compareTo(b.number);
        case MatchesSortOption.numberDesc:
          return b.number.compareTo(a.number);
        case MatchesSortOption.priceAsc:
          return a.price.compareTo(b.price);
        case MatchesSortOption.priceDesc:
          return b.price.compareTo(a.price);
      }
    });

    emit(MatchesSuccess(seats, sort: _sort));
  }
}
