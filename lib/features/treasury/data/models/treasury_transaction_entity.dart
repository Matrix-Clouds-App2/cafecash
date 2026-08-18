import 'package:objectbox/objectbox.dart';

import '../../../orders/data/models/order_entity.dart';

@Entity()
class TreasuryTransactionEntity {
  TreasuryTransactionEntity({
    this.id = 0,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.isIncome,
    this.paymentMethod,
    this.orderId,
    this.createdAt,
    this.createdBy,
  });

  int id;

  String title;

  String subtitle;

  double amount;

  bool isIncome;

  int? paymentMethod;

  @Index()
  int? orderId;

  @Property(type: PropertyType.date)
  DateTime? createdAt;

  String? createdBy;

  @Transient()
  PaymentMethod? get paymentMethodEnum =>
      paymentMethod == null ? null : PaymentMethod.values[paymentMethod!];

  set paymentMethodEnum(PaymentMethod? value) => paymentMethod = value?.index;
}
