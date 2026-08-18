import 'package:equatable/equatable.dart';

import '../../../orders/data/models/order_entity.dart';
import 'shift_entity.dart';

class ShiftSummary extends Equatable {
  const ShiftSummary({
    required this.shift,
    required this.totalIncome,
    required this.totalExpense,
    required this.paidOrders,
    required this.cancelledOrders,
    required this.itemsCount,
    required this.cashTotal,
    required this.walletTotal,
  });

  final ShiftEntity shift;
  final double totalIncome;
  final double totalExpense;

  final List<OrderEntity> paidOrders;
  final List<OrderEntity> cancelledOrders;
  final int itemsCount;
  final double cashTotal;
  final double walletTotal;

  double get closingBalance =>
      shift.openingBalance + totalIncome - totalExpense;

  @override
  List<Object?> get props => [
        shift,
        totalIncome,
        totalExpense,
        paidOrders,
        cancelledOrders,
        itemsCount,
        cashTotal,
        walletTotal,
      ];
}
