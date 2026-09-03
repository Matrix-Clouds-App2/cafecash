import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/widgets/subscription_guard.dart';
import '../data/hall_repo.dart';
import '../data/models/hall_table_entity.dart';

part 'hall_state.dart';

enum HallSortOption { numberAsc, numberDesc, priceAsc, priceDesc }

class HallCubit extends Cubit<HallState> {
  HallCubit(this._repo) : super(const HallInitial());

  final HallRepo _repo;
  StreamSubscription<List<HallTableEntity>>? _subscription;

  List<HallTableEntity> _all = [];
  String _query = '';
  HallSortOption _sort = HallSortOption.numberAsc;

  /// Subscribes to the live table list instead of a one-off fetch — the
  /// grid then updates on its own whenever a table changes, even when the
  /// write comes from another feature (e.g. `OrderCubit` marking a table
  /// occupied with a new total once an order gets items).
  void fetchTables() {
    emit(const HallLoading());
    _subscription?.cancel();
    _subscription = _repo.watchTables().listen(
      (tables) {
        _all = tables;
        _emitFiltered();
      },
      onError: (Object e) => emit(HallError(e.toString())),
    );
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }

  void addTable() {
    if (!SubscriptionGuard.ensureActive()) return;
    try {
      _repo.addTable();
      _all = _repo.getTables();
      _emitFiltered();
    } catch (e) {
      emit(HallError(e.toString()));
    }
  }

  void toggleStatus(HallTableEntity table) {
    if (!SubscriptionGuard.ensureActive()) return;
    final next = table.statusEnum == HallTableStatus.disabled
        ? HallTableStatus.available
        : HallTableStatus.disabled;
    _repo.setStatus(table.id, next);
    _all = _repo.getTables();
    _emitFiltered();
  }

  /// True only for the highest-numbered table (the tail of the list) — the
  /// one whose slot/number nothing else depends on, so it's safe to remove
  /// completely instead of just soft-deleting it.
  bool isLastTable(HallTableEntity table) {
    final maxNumber = _all
        .map((t) => t.number)
        .fold<int>(table.number, (a, b) => a > b ? a : b);
    return table.number >= maxNumber;
  }

  /// Deletes a table. If it's the highest-numbered table (the tail of the
  /// list), it's removed completely and its number is freed up for the next
  /// `addTable()`. Otherwise it's soft-deleted (marked disabled) so tables
  /// after it keep their numbers — no reshuffling/holes in the numbering.
  void deleteTable(HallTableEntity table) {
    if (!SubscriptionGuard.ensureActive()) return;
    if (isLastTable(table)) {
      _repo.deleteTable(table.id);
    } else {
      _repo.setStatus(table.id, HallTableStatus.disabled);
    }
    _all = _repo.getTables();
    _emitFiltered();
  }

  void search(String query) {
    _query = query;
    _emitFiltered();
  }

  void sort(HallSortOption option) {
    _sort = option;
    _emitFiltered();
  }

  void _emitFiltered() {
    final query = _query.trim().toLowerCase();
    var tables = _all.where((table) {
      if (query.isEmpty) return true;
      return table.number.toString().contains(query) ||
          table.price.toStringAsFixed(0).contains(query) ||
          (table.customerName ?? '').toLowerCase().contains(query);
    }).toList();

    tables.sort((a, b) {
      switch (_sort) {
        case HallSortOption.numberAsc:
          return a.number.compareTo(b.number);
        case HallSortOption.numberDesc:
          return b.number.compareTo(a.number);
        case HallSortOption.priceAsc:
          return a.price.compareTo(b.price);
        case HallSortOption.priceDesc:
          return b.price.compareTo(a.price);
      }
    });

    emit(HallSuccess(tables, sort: _sort));
  }
}
