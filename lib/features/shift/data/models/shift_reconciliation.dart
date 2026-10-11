import 'package:equatable/equatable.dart';

import 'shift_summary.dart';

class ShiftReconciliation extends Equatable {
  const ShiftReconciliation({
    required this.expectedCash,
    required this.expectedWallet,
    required this.actualCash,
    required this.actualWallet,
  });

  factory ShiftReconciliation.compute({
    required ShiftSummary summary,
    required double actualCash,
    required double actualWallet,
  }) {
    return ShiftReconciliation(
      expectedCash: summary.shift.openingBalance + summary.cashTotal,
      expectedWallet: summary.walletTotal,
      actualCash: actualCash,
      actualWallet: actualWallet,
    );
  }

  final double expectedCash;
  final double expectedWallet;
  final double actualCash;
  final double actualWallet;

  static const _epsilon = 0.01;

  double get expectedTotal => expectedCash + expectedWallet;
  double get actualTotal => actualCash + actualWallet;

  double get cashDifference => actualCash - expectedCash;
  double get walletDifference => actualWallet - expectedWallet;
  double get totalDifference => cashDifference + walletDifference;

  bool get isBalanced => totalDifference.abs() < _epsilon;
  bool get isDeficit => totalDifference < -_epsilon;
  bool get isSurplus => totalDifference > _epsilon;

  @override
  List<Object?> get props =>
      [expectedCash, expectedWallet, actualCash, actualWallet];
}
