import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/app_constants.dart';
import '../../../core/utils/app_overlay.dart';
import '../../../core/utils/locale_keys.dart';
import '../../shift/data/models/shift_entity.dart';
import '../../shift/data/shift_repo.dart';
import '../data/models/treasury_transaction_entity.dart';
import '../data/treasury_repo.dart';

part 'treasury_state.dart';

class TreasuryCubit extends Cubit<TreasuryState> {
  TreasuryCubit(this._repo, this._shiftRepo) : super(const TreasuryInitial());

  final TreasuryRepo _repo;
  final ShiftRepo _shiftRepo;
  StreamSubscription<List<TreasuryTransactionEntity>>? _subscription;

  void fetch() {
    emit(const TreasuryLoading());
    _subscription?.cancel();

    final activeShift = _shiftRepo.getActiveShift();

    _subscription = _repo.watchAll().listen(
      (transactions) {
        final scoped = _scopedToShift(transactions, activeShift);
        emit(TreasurySuccess(
          transactions: scoped,
          totalIncome: _repo.totalIncome(scoped),
          totalExpense: _repo.totalExpense(scoped),
          openingBalance: activeShift?.openingBalance ?? 0,
        ));
      },
      onError: (Object e) => emit(TreasuryError(e.toString())),
    );
  }

  List<TreasuryTransactionEntity> _scopedToShift(
      List<TreasuryTransactionEntity> transactions, ShiftEntity? shift) {
    final start = shift?.startedAt;
    if (start == null) return transactions;
    return transactions
        .where((t) => t.createdAt != null && !t.createdAt!.isBefore(start))
        .toList();
  }

  void addTransaction({
    required bool isIncome,
    required double amount,
    String? notes,
  }) {
    try {
      final title = isIncome
          ? LocaleKeys.treasury_receiveCash.tr()
          : LocaleKeys.treasury_withdrawCash.tr();
      final trimmedNotes = notes?.trim();
      final subtitle = (trimmedNotes != null && trimmedNotes.isNotEmpty)
          ? trimmedNotes
          : (isIncome
              ? LocaleKeys.treasury_manualIncomeSubtitle.tr()
              : LocaleKeys.treasury_manualExpenseSubtitle.tr());

      _repo.add(
        title: title,
        subtitle: subtitle,
        amount: amount,
        isIncome: isIncome,
        createdBy: kUserModel?.name,
      );
    } catch (e) {
      AppOverlay.showError(e.toString());
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
