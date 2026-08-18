import 'package:equatable/equatable.dart';

import '../../../orders/data/models/order_entity.dart';
import '../../../orders/data/models/order_location_kind.dart';

class PaidInvoice extends Equatable {
  const PaidInvoice({
    required this.number,
    required this.amount,
    required this.itemsCount,
    required this.locationNumber,
    required this.kind,
    required this.dateTime,
    required this.paymentMethod,
  });

  final String number;
  final double amount;
  final int itemsCount;
  final int locationNumber;

  final OrderLocationKind kind;
  final String dateTime;
  final PaymentMethod? paymentMethod;

  @override
  List<Object?> get props => [
        number,
        amount,
        itemsCount,
        locationNumber,
        kind,
        dateTime,
        paymentMethod
      ];
}
