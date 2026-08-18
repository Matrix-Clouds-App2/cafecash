import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/app_overlay.dart';
import '../data/models/shift_entity.dart';
import '../data/shift_repo.dart';

part 'shift_state.dart';

class ShiftCubit extends Cubit<ShiftState> {
  ShiftCubit(this._repo) : super(const ShiftInitial());

  final ShiftRepo _repo;
  StreamSubscription<ShiftEntity?>? _activeSubscription;
  StreamSubscription<List<ShiftEntity>>? _historySubscription;

  ShiftEntity? _active;
  List<ShiftEntity> _history = [];

  void watchActive() {
    emit(const ShiftLoading());
    _activeSubscription?.cancel();
    _historySubscription?.cancel();

    _activeSubscription = _repo.watchActiveShift().listen(
      (shift) {
        _active = shift;
        _emit();
      },
      onError: (Object e) => emit(ShiftError(e.toString())),
    );
    _historySubscription = _repo.watchHistory().listen(
      (history) {
        _history = history;
        _emit();
      },
      onError: (Object e) => emit(ShiftError(e.toString())),
    );
  }

  @override
  Future<void> close() {
    _activeSubscription?.cancel();
    _historySubscription?.cancel();
    return super.close();
  }

  void startShift(double openingBalance) {
    try {
      _repo.startShift(openingBalance: openingBalance);
    } catch (e) {
      AppOverlay.showError(e.toString());
    }
  }

  void closeShift(ShiftEntity shift, double closingBalance) {
    try {
      _repo.closeShift(shift, closingBalance: closingBalance);
    } catch (e) {
      AppOverlay.showError(e.toString());
    }
  }

  void _emit() => emit(ShiftReady(active: _active, history: _history));
}
