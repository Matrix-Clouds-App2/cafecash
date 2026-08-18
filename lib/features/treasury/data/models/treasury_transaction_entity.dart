import 'package:objectbox/objectbox.dart';

@Entity()
class TreasuryTransactionEntity {
  TreasuryTransactionEntity({
    this.id = 0,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.isIncome,
    this.createdAt,
    this.createdBy,
  });

  int id;

  String title;

  String subtitle;

  double amount;

  bool isIncome;

  @Property(type: PropertyType.date)
  DateTime? createdAt;

  String? createdBy;
}
