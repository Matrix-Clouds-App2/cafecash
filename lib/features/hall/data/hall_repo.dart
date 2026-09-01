import 'package:uuid/uuid.dart';

import '../../../core/storage/object_box/local_box.dart';
import '../../../core/storage/object_box/object_box_storage.dart';
import 'models/hall_table_entity.dart';

class HallRepo {
  HallRepo({required ObjectBoxStorage storage})
      : _box = storage.box<HallTableEntity>();

  final LocalBox<HallTableEntity> _box;

  List<HallTableEntity> getTables() {
    final tables = _box.getAll();
    tables.sort((a, b) => a.number.compareTo(b.number));
    return tables;
  }

  /// Live table list — fires again whenever *any* write hits this box, from
  /// `HallCubit`'s own mutations or from elsewhere (e.g. `OrderCubit`
  /// syncing a table's status/total via [syncOrderSummary]). `HallCubit`
  /// stays subscribed to this instead of doing one-off fetches, so the grid
  /// never goes stale just because a different feature touched a table.
  Stream<List<HallTableEntity>> watchTables() => _box
      .watchAll()
      .map((tables) => tables..sort((a, b) => a.number.compareTo(b.number)));

  HallTableEntity addTable() {
    final tables = _box.getAll();
    final nextNumber = tables.isEmpty
        ? 1
        : tables.map((t) => t.number).reduce((a, b) => a > b ? a : b) + 1;
    final table = HallTableEntity(number: nextNumber, uuid: const Uuid().v4());
    table.id = _box.put(table);
    return table;
  }

  void setStatus(int id, HallTableStatus status) {
    final table = _box.getById(id);
    if (table == null) return;
    table.statusEnum = status;
    _box.put(table);
  }

  void deleteTable(int id) {
    _box.remove(id);
  }

  /// Reflects an order's current items/total onto its table — called by
  /// `OrderCubit` after every order mutation. A table with a live order is
  /// [HallTableStatus.occupied] and shows the order's item count/price on
  /// its card; once the order is empty/paid/cancelled it goes back to
  /// [HallTableStatus.available] with those cleared.
  void syncOrderSummary({
    required int tableId,
    required HallTableStatus status,
    int drinkCount = 0,
    double price = 0,
    String? customerName,
  }) {
    final table = _box.getById(tableId);
    if (table == null) return;
    table
      ..statusEnum = status
      ..drinkCount = drinkCount
      ..price = price
      ..customerName = customerName;
    _box.put(table);
  }
}
