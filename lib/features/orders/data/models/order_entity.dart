import 'package:objectbox/objectbox.dart';

import 'order_location_kind.dart';

enum OrderStatus { active, deferred, paid, cancelled, rolledOver }

enum PaymentMethod { cash, wallet }

@Entity()
class OrderEntity {
  OrderEntity({
    this.id = 0,
    required this.tableId,
    required this.tableNumber,
    this.locationKind = 0,
    this.status = 0,
    this.customerId,
    this.customerName,
    this.paidAmount = 0,
    this.paymentMethod,
    this.createdAt,
    this.closedAt,
    this.createdBy,
    this.cancelReason,
    this.uuid = '',
    this.synced = false,
  });

  int id;

  @Index()
  int tableId;

  int tableNumber;

  int locationKind;

  int status;

  @Index()
  int? customerId;

  String? customerName;

  double paidAmount;

  int? paymentMethod;

  @Property(type: PropertyType.date)
  DateTime? createdAt;

  @Property(type: PropertyType.date)
  DateTime? closedAt;

  String? createdBy;

  String? cancelReason;

  @Index()
  String uuid;

  bool synced;

  @Transient()
  OrderStatus get statusEnum => OrderStatus.values[status];

  set statusEnum(OrderStatus value) => status = value.index;

  @Transient()
  OrderLocationKind get locationKindEnum =>
      OrderLocationKind.values[locationKind];

  set locationKindEnum(OrderLocationKind value) => locationKind = value.index;

  @Transient()
  PaymentMethod? get paymentMethodEnum =>
      paymentMethod == null ? null : PaymentMethod.values[paymentMethod!];

  set paymentMethodEnum(PaymentMethod? value) => paymentMethod = value?.index;
}
