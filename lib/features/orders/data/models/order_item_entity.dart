import 'package:objectbox/objectbox.dart';

import '../../../../core/utils/app_constants.dart';

/// One line item within an [OrderEntity]. `name`/`price`/`imagePath` are
/// snapshotted from the `MenuItemEntity` at the moment it's added, so
/// editing the menu later never retroactively changes an order already in
/// progress.
@Entity()
class OrderItemEntity {
  OrderItemEntity({
    this.id = 0,
    required this.orderId,
    required this.menuItemId,
    required this.name,
    this.nameEn,
    required this.price,
    this.imagePath,
    this.quantity = 1,
    this.uuid = '',
  });

  int id;

  @Index()
  int orderId;

  int menuItemId;

  String name;

  String? nameEn;

  double price;

  String? imagePath;

  int quantity;

  @Index()
  String uuid;
}

extension OrderItemLocalizedName on OrderItemEntity {
  String get displayName {
    final en = nameEn;
    if (!kIsArabic && en != null && en.trim().isNotEmpty) return en;
    return name;
  }
}
