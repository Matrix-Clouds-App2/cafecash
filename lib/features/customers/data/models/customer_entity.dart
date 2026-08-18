import 'package:objectbox/objectbox.dart';

@Entity()
class CustomerEntity {
  CustomerEntity({
    this.id = 0,
    required this.name,
    required this.phone,
    this.createdAt,
  });

  int id;

  String name;

  @Index()
  String phone;

  @Property(type: PropertyType.date)
  DateTime? createdAt;
}
