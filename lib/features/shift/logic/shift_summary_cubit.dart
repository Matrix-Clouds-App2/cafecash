import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../orders/data/orders_repo.dart';
import '../../treasury/data/treasury_repo.dart';
import '../data/models/shift_entity.dart';
import '../data/models/shift_summary.dart';
import 'shift_window.dart';

part 'shift_summary_state.dart';

class ShiftSummaryCubit extends Cubit<ShiftSummaryState> {
  ShiftSummaryCubit(this._ordersRepo, this._treasuryRepo)
      : super(const ShiftSummaryInitial());

  final OrdersRepo _ordersRepo;
  final TreasuryRepo _treasuryRepo;

  void load(ShiftEntity shift) {
    emit(const ShiftSummaryLoading());
    try {
      bool inWindow(DateTime? at) => ShiftWindow.contains(shift, at);

      final transactions =
          _treasuryRepo.getAll().where((t) => inWindow(t.createdAt)).toList();
      final totalIncome = _treasuryRepo.totalIncome(transactions);
      final totalExpense = _treasuryRepo.totalExpense(transactions);

      final paidOrders = _ordersRepo
          .getPaidOrders()
          .where((order) => inWindow(order.closedAt))
          .toList();

      final cancelledOrders = _ordersRepo
          .getCancelledOrders()
          .where((order) => inWindow(order.closedAt))
          .toList();

      var itemsCount = 0;
      for (final order in paidOrders) {
        itemsCount += _ordersRepo.orderItemsCount(order.id);
      }
      final cashTotal = _treasuryRepo.totalCash(transactions);
      final walletTotal = _treasuryRepo.totalWallet(transactions);

      emit(ShiftSummarySuccess(ShiftSummary(
        shift: shift,
        totalIncome: totalIncome,
        totalExpense: totalExpense,
        paidOrders: paidOrders,
        cancelledOrders: cancelledOrders,
        itemsCount: itemsCount,
        cashTotal: cashTotal,
        walletTotal: walletTotal,
      )));
    } catch (e) {
      emit(ShiftSummaryError(e.toString()));
    }
  }
}
