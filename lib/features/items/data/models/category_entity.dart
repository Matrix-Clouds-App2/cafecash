import 'package:objectbox/objectbox.dart';

@Entity()
class CategoryEntity {
  CategoryEntity({
    this.id = 0,
    required this.name,
    this.imagePath,
    this.createdAt,
    this.sortOrder = 0,
  });

  int id;

  String name;

  String? imagePath;

  @Property(type: PropertyType.date)
  DateTime? createdAt;

  int sortOrder;
}
