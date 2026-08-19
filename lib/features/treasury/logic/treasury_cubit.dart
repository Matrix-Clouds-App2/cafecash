import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/app_constants.dart';
import '../../../core/utils/app_overlay.dart';
import '../../../core/utils/locale_keys.dart';
import '../../orders/data/models/order_entity.dart';
import '../../orders/data/orders_repo.dart';
import '../../shift/data/models/shift_entity.dart';
import '../../shift/data/shift_repo.dart';
import '../data/models/treasury_transaction_entity.dart';
import '../data/treasury_repo.dart';

part 'treasury_state.dart';

class TreasuryCubit extends Cubit<TreasuryState> {
  TreasuryCubit(this._repo, this._shiftRepo, this._ordersRepo)
      : super(const TreasuryInitial());

  final TreasuryRepo _repo;
  final ShiftRepo _shiftRepo;
  final OrdersRepo _ordersRepo;
  StreamSubscription<List<TreasuryTransactionEntity>>? _subscription;

  void fetch() {
    emit(const TreasuryLoading());
    _subscription?.cancel();

    final activeShift = _shiftRepo.getActiveShift();

    _subscription = _repo.watchAll().listen(
      (transactions) {
        final scoped = _scopedToShift(transactions, activeShift);
        final openingBalance = activeShift?.openingBalance ?? 0;
        emit(TreasurySuccess(
          transactions: scoped,
          totalIncome: _repo.totalIncome(scoped),
          totalExpense: _repo.totalExpense(scoped),
          openingBalance: openingBalance,
          totalCash: _repo.totalCash(scoped),
          totalWallet: _repo.totalWallet(scoped),
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

  void fetchForShift(ShiftEntity shift) {
    emit(const TreasuryLoading());
    _subscription?.cancel();

    _subscription = _repo.watchAll().listen(
      (transactions) {
        final scoped = _scopedToWindow(transactions, shift);
        emit(TreasurySuccess(
          transactions: scoped,
          totalIncome: _repo.totalIncome(scoped),
          totalExpense: _repo.totalExpense(scoped),
          openingBalance: shift.openingBalance,
          totalCash: _repo.totalCash(scoped),
          totalWallet: _repo.totalWallet(scoped),
        ));
      },
      onError: (Object e) => emit(TreasuryError(e.toString())),
    );
  }

  List<TreasuryTransactionEntity> _scopedToWindow(
      List<TreasuryTransactionEntity> transactions, ShiftEntity shift) {
    final start = shift.startedAt;
    if (start == null) return transactions;
    final end = shift.closedAt ?? DateTime.now();
    return transactions
        .where((t) =>
            t.createdAt != null &&
            !t.createdAt!.isBefore(start) &&
            !t.createdAt!.isAfter(end))
        .toList();
  }

  void addTransaction({
    required bool isIncome,
    required double amount,
    String? notes,
    PaymentMethod? paymentMethod,
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
        paymentMethod: paymentMethod,
        createdBy: kUserModel?.name,
      );
    } catch (e) {
      AppOverlay.showError(e.toString());
    }
  }

  void updatePaymentMethod(
    TreasuryTransactionEntity transaction,
    PaymentMethod method,
  ) {
    try {
      _repo.updatePaymentMethod(transaction, method);
      final orderId = transaction.orderId;
      if (orderId != null) {
        final order = _ordersRepo.getById(orderId);
        if (order != null) _ordersRepo.updatePaymentMethod(order, method);
      }
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
