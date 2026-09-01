import 'package:objectbox/objectbox.dart';

import '../../../../core/utils/app_constants.dart';

@Entity()
class CategoryEntity {
  CategoryEntity({
    this.id = 0,
    required this.name,
    this.nameEn,
    this.imagePath,
    this.createdAt,
    this.sortOrder = 0,
    this.uuid = '',
    this.synced = false,
    this.isDefault = false,
  });

  int id;

  String name;

  String? nameEn;

  String? imagePath;

  @Property(type: PropertyType.date)
  DateTime? createdAt;

  int sortOrder;

  @Index()
  String uuid;

  bool synced;

  bool isDefault;

  @override
  String toString() =>
      'CategoryEntity(id: $id, uuid: $uuid, name: $name, nameEn: $nameEn, '
      'sortOrder: $sortOrder, isDefault: $isDefault, synced: $synced, '
      'imagePath: $imagePath, createdAt: $createdAt)';
}

extension CategoryLocalizedName on CategoryEntity {
  String get displayName {
    final en = nameEn;
    if (!kIsArabic && en != null && en.trim().isNotEmpty) return en;
    return name;
  }
}
