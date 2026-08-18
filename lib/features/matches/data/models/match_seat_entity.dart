import 'package:objectbox/objectbox.dart';

enum MatchSeatStatus { available, occupied, disabled }

@Entity()
class MatchSeatEntity {
  MatchSeatEntity({
    this.id = 0,
    required this.number,
    this.status = 0,
    this.drinkCount = 0,
    this.price = 0,
    this.customerName,
  });

  int id;

  @Index()
  int number;

  int status;

  int drinkCount;

  double price;

  String? customerName;

  @Transient()
  MatchSeatStatus get statusEnum => MatchSeatStatus.values[status];

  set statusEnum(MatchSeatStatus value) => status = value.index;
}
