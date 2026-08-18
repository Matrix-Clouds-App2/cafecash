import 'package:objectbox/objectbox.dart';

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
    required this.price,
    this.imagePath,
    this.quantity = 1,
  });

  int id;

  @Index()
  int orderId;

  int menuItemId;

  String name;

  double price;

  String? imagePath;

  int quantity;
}
