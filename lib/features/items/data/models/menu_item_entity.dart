import 'package:objectbox/objectbox.dart';

import '../../../../core/utils/app_constants.dart';

@Entity()
class MenuItemEntity {
  MenuItemEntity({
    this.id = 0,
    required this.categoryId,
    required this.name,
    this.nameEn,
    required this.price,
    this.imagePath,
    this.createdAt,
    this.sortOrder = 0,
    this.uuid = '',
    this.synced = false,
    this.isDefault = false,
  });

  int id;

  @Index()
  int categoryId;

  String name;

  String? nameEn;

  double price;

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
      'MenuItemEntity(id: $id, uuid: $uuid, categoryId: $categoryId, '
      'name: $name, nameEn: $nameEn, price: $price, sortOrder: $sortOrder, '
      'isDefault: $isDefault, synced: $synced, imagePath: $imagePath)';
}

extension MenuItemLocalizedName on MenuItemEntity {
  String get displayName {
    final en = nameEn;
    if (!kIsArabic && en != null && en.trim().isNotEmpty) return en;
    return name;
  }
}
