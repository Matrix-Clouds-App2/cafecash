import 'package:objectbox/objectbox.dart';

enum ShiftStatus { open, closed }

@Entity()
class ShiftEntity {
  ShiftEntity({
    this.id = 0,
    required this.openingBalance,
    this.status = 0,
    this.startedAt,
    this.closedAt,
    this.closingBalance,
  });

  int id;

  double openingBalance;

  int status;

  @Property(type: PropertyType.date)
  DateTime? startedAt;

  @Property(type: PropertyType.date)
  DateTime? closedAt;

  double? closingBalance;

  @Transient()
  ShiftStatus get statusEnum => ShiftStatus.values[status];

  set statusEnum(ShiftStatus value) => status = value.index;
}
