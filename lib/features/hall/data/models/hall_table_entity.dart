import 'package:objectbox/objectbox.dart';

enum HallTableStatus { available, occupied, disabled }

@Entity()
class HallTableEntity {
  HallTableEntity({
    this.id = 0,
    required this.number,
    this.status = 0,
    this.drinkCount = 0,
    this.price = 0,
    this.customerName,
    this.uuid = '',
  });

  int id;

  @Index()
  int number;

  int status;

  int drinkCount;

  double price;

  String? customerName;

  @Index()
  String uuid;

  @Transient()
  HallTableStatus get statusEnum => HallTableStatus.values[status];

  set statusEnum(HallTableStatus value) => status = value.index;
}
