import 'package:objectbox/objectbox.dart';

@Entity()
class MenuItemEntity {
  MenuItemEntity({
    this.id = 0,
    required this.categoryId,
    required this.name,
    required this.price,
    this.imagePath,
    this.createdAt,
    this.sortOrder = 0,
  });

  int id;

  @Index()
  int categoryId;

  String name;

  double price;

  String? imagePath;

  @Property(type: PropertyType.date)
  DateTime? createdAt;

  int sortOrder;
}
