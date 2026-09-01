import 'package:uuid/uuid.dart';

import '../../../features/customers/data/models/customer_entity.dart';
import '../../../features/hall/data/models/hall_table_entity.dart';
import '../../../features/items/data/models/category_entity.dart';
import '../../../features/items/data/models/menu_item_entity.dart';
import '../../../features/matches/data/models/match_seat_entity.dart';
import '../../../features/orders/data/models/order_entity.dart';
import '../../../features/orders/data/models/order_item_entity.dart';
import '../../../features/shift/data/models/shift_entity.dart';
import '../../../features/treasury/data/models/treasury_transaction_entity.dart';
import '../local_storage.dart';
import 'object_box_storage.dart';

const _uuid = Uuid();

Future<void> backfillUuidsIfNeeded(
    ObjectBoxStorage storage, LocalStorage localStorage) async {
  if (localStorage.isUuidBackfillDone) return;

  _backfill<CustomerEntity>(storage, (e) => e.uuid, (e, v) => e.uuid = v);
  _backfill<CategoryEntity>(storage, (e) => e.uuid, (e, v) => e.uuid = v);
  _backfill<MenuItemEntity>(storage, (e) => e.uuid, (e, v) => e.uuid = v);
  _backfill<OrderEntity>(storage, (e) => e.uuid, (e, v) => e.uuid = v);
  _backfill<OrderItemEntity>(storage, (e) => e.uuid, (e, v) => e.uuid = v);
  _backfill<TreasuryTransactionEntity>(
      storage, (e) => e.uuid, (e, v) => e.uuid = v);
  _backfill<ShiftEntity>(storage, (e) => e.uuid, (e, v) => e.uuid = v);
  _backfill<HallTableEntity>(storage, (e) => e.uuid, (e, v) => e.uuid = v);
  _backfill<MatchSeatEntity>(storage, (e) => e.uuid, (e, v) => e.uuid = v);

  await localStorage.setUuidBackfillDone();
}

void _backfill<T>(
  ObjectBoxStorage storage,
  String Function(T) uuidOf,
  void Function(T, String) setUuid,
) {
  final box = storage.box<T>();
  final all = box.getAll();
  final toUpdate = <T>[];
  for (final entity in all) {
    if (uuidOf(entity).isEmpty) {
      setUuid(entity, _uuid.v4());
      toUpdate.add(entity);
    }
  }
  if (toUpdate.isNotEmpty) box.putMany(toUpdate);
}
