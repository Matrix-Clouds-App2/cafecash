import 'package:path_provider/path_provider.dart';

import '../../../objectbox.g.dart';
import '../../../features/customers/data/models/customer_entity.dart';
import '../../../features/hall/data/models/hall_table_entity.dart';
import '../../../features/items/data/models/category_entity.dart';
import '../../../features/items/data/models/menu_item_entity.dart';
import '../../../features/matches/data/models/match_seat_entity.dart';
import '../../../features/orders/data/models/order_entity.dart';
import '../../../features/orders/data/models/order_item_entity.dart';
import '../../../features/shift/data/models/shift_entity.dart';
import '../../../features/treasury/data/models/treasury_transaction_entity.dart';
import 'entities/cache_meta_entity.dart';
import 'entities/pending_deletion_entity.dart';
import 'local_box.dart';

class ObjectBoxStorage {
  ObjectBoxStorage._(this.store);

  final Store store;

  static Future<ObjectBoxStorage> create() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final store = await openStore(directory: '${docsDir.path}/objectbox');
    return ObjectBoxStorage._(store);
  }

  LocalBox<T> box<T>() => LocalBox<T>(store.box<T>());

  void wipeAllBusinessData() {
    store.box<CategoryEntity>().removeAll();
    store.box<MenuItemEntity>().removeAll();
    store.box<CustomerEntity>().removeAll();
    store.box<OrderEntity>().removeAll();
    store.box<OrderItemEntity>().removeAll();
    store.box<TreasuryTransactionEntity>().removeAll();
    store.box<HallTableEntity>().removeAll();
    store.box<MatchSeatEntity>().removeAll();
    store.box<ShiftEntity>().removeAll();
    store.box<PendingDeletionEntity>().removeAll();
    store.box<CacheMetaEntity>().removeAll();
  }

  DateTime? lastSyncedAt(String boxName) {
    final query = store
        .box<CacheMetaEntity>()
        .query(CacheMetaEntity_.boxName.equals(boxName))
        .build();
    final meta = query.findFirst();
    query.close();
    return meta?.lastSyncedAt;
  }

  void markSynced(String boxName) {
    final metaBox = store.box<CacheMetaEntity>();
    final query =
        metaBox.query(CacheMetaEntity_.boxName.equals(boxName)).build();
    final existing = query.findFirst();
    query.close();
    metaBox.put(CacheMetaEntity(
      id: existing?.id ?? 0,
      boxName: boxName,
      lastSyncedAt: DateTime.now(),
    ));
  }

  void close() => store.close();
}
