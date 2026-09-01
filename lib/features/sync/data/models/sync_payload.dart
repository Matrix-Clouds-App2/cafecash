import '../../../customers/data/models/customer_entity.dart';
import '../../../items/data/models/category_entity.dart';
import '../../../items/data/models/menu_item_entity.dart';
import '../../../orders/data/models/order_entity.dart';
import 'sync_image_ref.dart';

class SyncPayload {
  const SyncPayload({
    required this.json,
    required this.imageRefs,
    required this.customersToMarkSynced,
    required this.categoriesToMarkSynced,
    required this.itemsToMarkSynced,
    required this.ordersToMarkSynced,
    required this.deletionIdsToConsume,
  });

  final Map<String, dynamic> json;
  final List<SyncImageRef> imageRefs;
  final List<CustomerEntity> customersToMarkSynced;
  final List<CategoryEntity> categoriesToMarkSynced;
  final List<MenuItemEntity> itemsToMarkSynced;
  final List<OrderEntity> ordersToMarkSynced;
  final List<int> deletionIdsToConsume;
}
