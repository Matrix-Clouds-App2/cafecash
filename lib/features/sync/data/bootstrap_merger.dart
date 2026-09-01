import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';

import '../../../core/network/api_endpoints.dart';
import '../../../core/storage/object_box/local_box.dart';
import '../../../core/storage/object_box/object_box_storage.dart';
import '../../../core/utils/local_image_picker.dart';
import '../../../core/utils/locale_keys.dart';
import '../../customers/data/models/customer_entity.dart';
import '../../hall/data/models/hall_table_entity.dart';
import '../../items/data/models/category_entity.dart';
import '../../items/data/models/menu_item_entity.dart';
import '../../matches/data/models/match_seat_entity.dart';
import '../../orders/data/models/order_entity.dart';
import '../../orders/data/models/order_item_entity.dart';
import '../../shift/data/models/shift_entity.dart';
import '../../treasury/data/models/treasury_transaction_entity.dart';
import 'models/bootstrap_merge_plan.dart';
import 'models/bootstrap_snapshot.dart';

class BootstrapMerger {
  BootstrapMerger({required ObjectBoxStorage storage})
      : _categoryBox = storage.box<CategoryEntity>(),
        _itemBox = storage.box<MenuItemEntity>(),
        _customerBox = storage.box<CustomerEntity>(),
        _orderBox = storage.box<OrderEntity>(),
        _orderItemBox = storage.box<OrderItemEntity>(),
        _treasuryBox = storage.box<TreasuryTransactionEntity>(),
        _tableBox = storage.box<HallTableEntity>(),
        _seatBox = storage.box<MatchSeatEntity>();

  final LocalBox<CategoryEntity> _categoryBox;
  final LocalBox<MenuItemEntity> _itemBox;
  final LocalBox<CustomerEntity> _customerBox;
  final LocalBox<OrderEntity> _orderBox;
  final LocalBox<OrderItemEntity> _orderItemBox;
  final LocalBox<TreasuryTransactionEntity> _treasuryBox;
  final LocalBox<HallTableEntity> _tableBox;
  final LocalBox<MatchSeatEntity> _seatBox;

  BootstrapMergePlan plan(BootstrapSnapshot snapshot) {
    final conflicts = <BootstrapConflict>[];

    final localCats = _byUuid(_categoryBox.getAll(), (c) => c.uuid);
    final serverCatUuids = snapshot.categories.map((c) => c.uuid).toSet();

    for (final s in snapshot.categories) {
      final local = localCats[s.uuid];
      if (local == null || local.synced) continue;
      final fields = _categoryFields(local, s);
      if (fields.isNotEmpty) {
        conflicts.add(BootstrapConflict(
          kind: BootstrapConflictKind.category,
          uuid: s.uuid,
          title: local.name,
          fields: fields,
          localImage: local.imagePath,
          serverImage: _resolveImage(s.imageKey, s.localAssetPath),
        ));
      }
    }

    for (final uuid in snapshot.deletedCategories) {
      final local = localCats[uuid];
      if (local == null || serverCatUuids.contains(uuid)) continue;
      if (!local.synced) {
        conflicts.add(BootstrapConflict(
          kind: BootstrapConflictKind.category,
          uuid: uuid,
          title: local.name,
          fields: const [],
          localImage: local.imagePath,
          deletedOnServer: true,
        ));
      }
    }

    final localItems = _byUuid(_itemBox.getAll(), (i) => i.uuid);
    final serverItemUuids = snapshot.menuItems.map((i) => i.uuid).toSet();

    for (final s in snapshot.menuItems) {
      final local = localItems[s.uuid];
      if (local == null || local.synced) continue;
      final fields = _menuItemFields(local, s);
      if (fields.isNotEmpty) {
        conflicts.add(BootstrapConflict(
          kind: BootstrapConflictKind.menuItem,
          uuid: s.uuid,
          title: local.name,
          fields: fields,
          localImage: local.imagePath,
          serverImage: _resolveImage(s.imageKey, s.localAssetPath),
        ));
      }
    }

    for (final uuid in snapshot.deletedMenuItems) {
      final local = localItems[uuid];
      if (local == null || serverItemUuids.contains(uuid)) continue;
      if (!local.synced) {
        conflicts.add(BootstrapConflict(
          kind: BootstrapConflictKind.menuItem,
          uuid: uuid,
          title: local.name,
          fields: const [],
          localImage: local.imagePath,
          deletedOnServer: true,
        ));
      }
    }

    final localCustomers = _byUuid(_customerBox.getAll(), (c) => c.uuid);
    final serverCustomerUuids = snapshot.customers.map((c) => c.uuid).toSet();

    for (final s in snapshot.customers) {
      final local = localCustomers[s.uuid];
      if (local == null || local.synced) continue;
      final fields = _customerFields(local, s);
      if (fields.isNotEmpty) {
        conflicts.add(BootstrapConflict(
          kind: BootstrapConflictKind.customer,
          uuid: s.uuid,
          title: local.name,
          fields: fields,
        ));
      }
    }

    for (final uuid in snapshot.deletedCustomers) {
      final local = localCustomers[uuid];
      if (local == null || serverCustomerUuids.contains(uuid)) continue;
      if (!local.synced) {
        conflicts.add(BootstrapConflict(
          kind: BootstrapConflictKind.customer,
          uuid: uuid,
          title: local.name,
          fields: const [],
          deletedOnServer: true,
        ));
      }
    }

    return BootstrapMergePlan(snapshot: snapshot, conflicts: conflicts);
  }

  Future<BootstrapMergeResult> apply(
    BootstrapMergePlan mergePlan,
    Map<String, BootstrapConflictChoice> choices,
  ) async {
    final snapshot = mergePlan.snapshot;
    final orphanImages = <String>[];

    var categoriesUpserted = 0;
    var menuItemsUpserted = 0;
    var customersUpserted = 0;
    var rowsDeleted = 0;
    var ordersImported = 0;
    var treasuryImported = 0;
    var conflictsResolved = 0;

    BootstrapConflictChoice choiceFor(String uuid) =>
        choices[uuid] ?? BootstrapConflictChoice.takeServer;

    final conflictUuids = {for (final c in mergePlan.conflicts) c.uuid};
    final claimedCategoryIds = <int>{};
    final claimedItemIds = <int>{};

    // ── categories ──
    final serverCatUuids = snapshot.categories.map((c) => c.uuid).toSet();
    final localCats = _byUuid(_categoryBox.getAll(), (c) => c.uuid);
    for (final s in snapshot.categories) {
      final local = localCats[s.uuid];
      if (local == null) {
        final adopt = _adoptableCategory(s, serverCatUuids, claimedCategoryIds);
        if (adopt != null) {
          claimedCategoryIds.add(adopt.id);
          _applyCategory(adopt, s, orphanImages);
          adopt.uuid = s.uuid;
          _categoryBox.put(adopt);
          categoriesUpserted++;
          continue;
        }
        _categoryBox.put(_newCategory(s));
        categoriesUpserted++;
        continue;
      }
      if (!local.synced && conflictUuids.contains(s.uuid)) {
        if (choiceFor(s.uuid) == BootstrapConflictChoice.keepLocal) {
          conflictsResolved++;
          continue;
        }
        conflictsResolved++;
      }
      _applyCategory(local, s, orphanImages);
      _categoryBox.put(local);
      categoriesUpserted++;
    }

    final catsByUuid = _byUuid(_categoryBox.getAll(), (c) => c.uuid);

    // ── menu items ──
    final serverItemUuids = snapshot.menuItems.map((i) => i.uuid).toSet();
    final localItems = _byUuid(_itemBox.getAll(), (i) => i.uuid);
    for (final s in snapshot.menuItems) {
      final categoryId = catsByUuid[s.categoryUuid]?.id;
      if (categoryId == null) {
        if (kDebugMode) {
          debugPrint(
              '╟ bootstrap: menu item ${s.uuid} skipped — category ${s.categoryUuid} not found');
        }
        continue;
      }
      final local = localItems[s.uuid];
      if (local == null) {
        final adopt =
            _adoptableItem(s, categoryId, serverItemUuids, claimedItemIds);
        if (adopt != null) {
          claimedItemIds.add(adopt.id);
          _applyMenuItem(adopt, s, categoryId, orphanImages);
          adopt.uuid = s.uuid;
          _itemBox.put(adopt);
          menuItemsUpserted++;
          continue;
        }
        _itemBox.put(_newMenuItem(s, categoryId));
        menuItemsUpserted++;
        continue;
      }
      if (!local.synced && conflictUuids.contains(s.uuid)) {
        if (choiceFor(s.uuid) == BootstrapConflictChoice.keepLocal) {
          conflictsResolved++;
          continue;
        }
        conflictsResolved++;
      }
      _applyMenuItem(local, s, categoryId, orphanImages);
      _itemBox.put(local);
      menuItemsUpserted++;
    }

    // ── customers ──
    final localCustomers = _byUuid(_customerBox.getAll(), (c) => c.uuid);
    for (final s in snapshot.customers) {
      final local = localCustomers[s.uuid];
      if (local == null) {
        _customerBox.put(CustomerEntity(
          name: s.name,
          phone: s.phone,
          createdAt: DateTime.now(),
          uuid: s.uuid,
          synced: true,
        ));
        customersUpserted++;
        continue;
      }
      if (!local.synced && conflictUuids.contains(s.uuid)) {
        if (choiceFor(s.uuid) == BootstrapConflictChoice.keepLocal) {
          conflictsResolved++;
          continue;
        }
        conflictsResolved++;
      }
      local
        ..name = s.name
        ..phone = s.phone
        ..synced = true;
      _customerBox.put(local);
      customersUpserted++;
    }

    // ── deletions ──
    rowsDeleted += _applyDeletions(
      uuids: snapshot.deletedCategories,
      serverUuids: serverCatUuids,
      conflictUuids: conflictUuids,
      choiceFor: choiceFor,
      onResolved: () => conflictsResolved++,
      deleteLocal: _deleteCategoryByUuid,
    );
    rowsDeleted += _applyDeletions(
      uuids: snapshot.deletedMenuItems,
      serverUuids: serverItemUuids,
      conflictUuids: conflictUuids,
      choiceFor: choiceFor,
      onResolved: () => conflictsResolved++,
      deleteLocal: _deleteMenuItemByUuid,
    );
    rowsDeleted += _applyDeletions(
      uuids: snapshot.deletedCustomers,
      serverUuids: snapshot.customers.map((c) => c.uuid).toSet(),
      conflictUuids: conflictUuids,
      choiceFor: choiceFor,
      onResolved: () => conflictsResolved++,
      deleteLocal: _deleteCustomerByUuid,
    );

    // ── orders ──
    ordersImported = _importOrders(snapshot);

    // ── treasury ──
    treasuryImported = _importTreasury(snapshot);

    // ── payments (debt collection) ──
    _applyPayments(snapshot);

    for (final path in orphanImages) {
      try {
        await LocalImagePicker.deleteIfExists(path);
      } catch (_) {}
    }

    return BootstrapMergeResult(
      categoriesUpserted: categoriesUpserted,
      menuItemsUpserted: menuItemsUpserted,
      customersUpserted: customersUpserted,
      rowsDeleted: rowsDeleted,
      ordersImported: ordersImported,
      treasuryImported: treasuryImported,
      conflictsResolved: conflictsResolved,
    );
  }

  int importShiftData(BootstrapSnapshot snapshot, ShiftEntity shift) {
    final imported = _importOrders(snapshot);
    _importTreasury(snapshot);
    _applyPayments(snapshot);
    _expandShiftWindow(snapshot, shift);
    return imported;
  }

  void _expandShiftWindow(BootstrapSnapshot snapshot, ShiftEntity shift) {
    final times = <DateTime>[
      for (final o in snapshot.orders) ...[
        if (o.createdAt != null) o.createdAt!,
        if (o.closedAt != null) o.closedAt!,
      ],
      for (final t in snapshot.treasury)
        if (t.createdAt != null) t.createdAt!,
    ];
    if (times.isEmpty) return;

    var start = shift.startedAt;
    var end = shift.closedAt;
    for (final t in times) {
      if (start == null || t.isBefore(start)) start = t;
      if (end == null || t.isAfter(end)) end = t;
    }
    shift
      ..startedAt = start
      ..closedAt = end;
  }

  // ── field comparison ──

  List<BootstrapConflictField> _categoryFields(CategoryEntity l, BsCategory s) {
    final out = <BootstrapConflictField>[];
    if (l.name != s.name) {
      out.add(BootstrapConflictField(
        label: LocaleKeys.sync_conflictFieldName.tr(),
        localValue: l.name,
        serverValue: s.name,
      ));
    }
    if (l.sortOrder != s.sortOrder) {
      out.add(BootstrapConflictField(
        label: LocaleKeys.sync_conflictFieldOrder.tr(),
        localValue: '${l.sortOrder}',
        serverValue: '${s.sortOrder}',
      ));
    }
    return out;
  }

  List<BootstrapConflictField> _menuItemFields(MenuItemEntity l, BsMenuItem s) {
    final out = <BootstrapConflictField>[];
    if (l.name != s.name) {
      out.add(BootstrapConflictField(
        label: LocaleKeys.sync_conflictFieldName.tr(),
        localValue: l.name,
        serverValue: s.name,
      ));
    }
    if (l.price != s.price) {
      out.add(BootstrapConflictField(
        label: LocaleKeys.sync_conflictFieldPrice.tr(),
        localValue: l.price.toStringAsFixed(2),
        serverValue: s.price.toStringAsFixed(2),
      ));
    }
    if (l.sortOrder != s.sortOrder) {
      out.add(BootstrapConflictField(
        label: LocaleKeys.sync_conflictFieldOrder.tr(),
        localValue: '${l.sortOrder}',
        serverValue: '${s.sortOrder}',
      ));
    }
    return out;
  }

  List<BootstrapConflictField> _customerFields(CustomerEntity l, BsCustomer s) {
    final out = <BootstrapConflictField>[];
    if (l.name != s.name) {
      out.add(BootstrapConflictField(
        label: LocaleKeys.sync_conflictFieldName.tr(),
        localValue: l.name,
        serverValue: s.name,
      ));
    }
    if (l.phone != s.phone) {
      out.add(BootstrapConflictField(
        label: LocaleKeys.sync_conflictFieldPhone.tr(),
        localValue: l.phone,
        serverValue: s.phone,
      ));
    }
    return out;
  }

  // ── adopt local seeded defaults instead of duplicating ──

  CategoryEntity? _adoptableCategory(
      BsCategory s, Set<String> serverUuids, Set<int> claimed) {
    for (final c in _categoryBox.getAll()) {
      if (claimed.contains(c.id)) continue;
      if (!c.isDefault || c.synced) continue;
      if (c.name != s.name) continue;
      if (serverUuids.contains(c.uuid)) continue;
      return c;
    }
    return null;
  }

  MenuItemEntity? _adoptableItem(BsMenuItem s, int categoryId,
      Set<String> serverUuids, Set<int> claimed) {
    for (final i in _itemBox.getAll()) {
      if (claimed.contains(i.id)) continue;
      if (!i.isDefault || i.synced) continue;
      if (i.categoryId != categoryId || i.name != s.name) continue;
      if (serverUuids.contains(i.uuid)) continue;
      return i;
    }
    return null;
  }

  // ── builders / updaters ──

  CategoryEntity _newCategory(BsCategory s) => CategoryEntity(
        name: s.name,
        imagePath: _resolveImage(s.imageKey, s.localAssetPath),
        createdAt: DateTime.now(),
        sortOrder: s.sortOrder,
        uuid: s.uuid,
        synced: true,
        isDefault: s.isDefault,
      );

  void _applyCategory(
      CategoryEntity local, BsCategory s, List<String> orphanImages) {
    final newImage = _resolveImage(s.imageKey, s.localAssetPath);
    _trackOrphan(local.imagePath, newImage, orphanImages);
    local
      ..name = s.name
      ..sortOrder = s.sortOrder
      ..isDefault = s.isDefault
      ..imagePath = newImage
      ..synced = true;
  }

  MenuItemEntity _newMenuItem(BsMenuItem s, int categoryId) => MenuItemEntity(
        categoryId: categoryId,
        name: s.name,
        price: s.price,
        imagePath: _resolveImage(s.imageKey, s.localAssetPath),
        createdAt: DateTime.now(),
        sortOrder: s.sortOrder,
        uuid: s.uuid,
        synced: true,
        isDefault: s.isDefault,
      );

  void _applyMenuItem(MenuItemEntity local, BsMenuItem s, int categoryId,
      List<String> orphanImages) {
    final newImage = _resolveImage(s.imageKey, s.localAssetPath);
    _trackOrphan(local.imagePath, newImage, orphanImages);
    local
      ..categoryId = categoryId
      ..name = s.name
      ..price = s.price
      ..sortOrder = s.sortOrder
      ..isDefault = s.isDefault
      ..imagePath = newImage
      ..synced = true;
  }

  // ── deletions ──

  int _applyDeletions({
    required List<String> uuids,
    required Set<String> serverUuids,
    required Set<String> conflictUuids,
    required BootstrapConflictChoice Function(String) choiceFor,
    required VoidCallback onResolved,
    required bool Function(String) deleteLocal,
  }) {
    var count = 0;
    for (final uuid in uuids) {
      if (serverUuids.contains(uuid)) continue;
      if (conflictUuids.contains(uuid)) {
        onResolved();
        if (choiceFor(uuid) == BootstrapConflictChoice.keepLocal) continue;
      }
      if (deleteLocal(uuid)) count++;
    }
    return count;
  }

  bool _deleteCategoryByUuid(String uuid) {
    final local = _firstByUuid(_categoryBox.getAll(), (c) => c.uuid, uuid);
    if (local == null) return false;
    final items =
        _itemBox.getAll().where((i) => i.categoryId == local.id).toList();
    _itemBox.removeMany(items.map((i) => i.id).toList());
    _categoryBox.remove(local.id);
    return true;
  }

  bool _deleteMenuItemByUuid(String uuid) {
    final local = _firstByUuid(_itemBox.getAll(), (i) => i.uuid, uuid);
    if (local == null) return false;
    _itemBox.remove(local.id);
    return true;
  }

  bool _deleteCustomerByUuid(String uuid) {
    final local = _firstByUuid(_customerBox.getAll(), (c) => c.uuid, uuid);
    if (local == null) return false;
    _customerBox.remove(local.id);
    return true;
  }

  // ── orders / treasury / payments ──

  int _importOrders(BootstrapSnapshot snapshot) {
    final existing = _orderBox
        .getAll()
        .where((o) => o.uuid.isNotEmpty)
        .map((o) => o.uuid)
        .toSet();
    final customersByUuid = _byUuid(_customerBox.getAll(), (c) => c.uuid);
    final itemsByUuid = _byUuid(_itemBox.getAll(), (i) => i.uuid);
    final tablesByUuid = _byUuid(_tableBox.getAll(), (t) => t.uuid);
    final seatsByUuid = _byUuid(_seatBox.getAll(), (s) => s.uuid);

    var count = 0;
    for (final bo in snapshot.orders) {
      if (bo.uuid.isEmpty || existing.contains(bo.uuid)) continue;

      final customer = customersByUuid[bo.customerUuid];
      final tableId = tablesByUuid[bo.tableUuid]?.id ??
          seatsByUuid[bo.tableUuid]?.id ??
          0;

      final order = OrderEntity(
        tableId: tableId,
        tableNumber: bo.tableNumber,
        status: bo.status.index,
        customerId: customer?.id,
        customerName: customer?.name,
        paidAmount: bo.paidAmount,
        paymentMethod: _paymentIndex(bo.paymentMethod),
        createdAt: bo.createdAt,
        closedAt: bo.closedAt,
        cancelReason: bo.cancelReason,
        uuid: bo.uuid,
        synced: true,
      );
      final orderId = _orderBox.put(order);

      for (final bi in bo.items) {
        _orderItemBox.put(OrderItemEntity(
          orderId: orderId,
          menuItemId: itemsByUuid[bi.menuItemUuid]?.id ?? 0,
          name: bi.name,
          price: bi.price,
          quantity: bi.quantity,
          uuid: bi.uuid,
        ));
      }
      count++;
    }
    return count;
  }

  int _importTreasury(BootstrapSnapshot snapshot) {
    final existing = _treasuryBox
        .getAll()
        .where((t) => t.uuid.isNotEmpty)
        .map((t) => t.uuid)
        .toSet();

    var count = 0;
    for (final bt in snapshot.treasury) {
      if (bt.uuid.isEmpty || existing.contains(bt.uuid)) continue;
      _treasuryBox.put(TreasuryTransactionEntity(
        title: bt.title,
        subtitle: bt.subtitle,
        amount: bt.amount,
        isIncome: bt.isIncome,
        createdAt: bt.createdAt,
        createdById: bt.employeeId,
        uuid: bt.uuid,
      ));
      count++;
    }
    return count;
  }

  void _applyPayments(BootstrapSnapshot snapshot) {
    if (snapshot.payments.isEmpty) return;
    final ordersByUuid = _byUuid(_orderBox.getAll(), (o) => o.uuid);
    for (final bp in snapshot.payments) {
      if (bp.type != 'debt_collection' || bp.orderUuid == null) continue;
      final order = ordersByUuid[bp.orderUuid];
      if (order == null || order.statusEnum != OrderStatus.deferred) continue;
      order
        ..statusEnum = OrderStatus.paid
        ..paymentMethod = _paymentIndex(bp.paymentMethod) ?? order.paymentMethod
        ..closedAt = order.closedAt ?? bp.paidAt
        ..synced = true;
      _orderBox.put(order);
    }
  }

  // ── helpers ──

  int? _paymentIndex(String? method) {
    switch (method) {
      case 'cash':
        return PaymentMethod.cash.index;
      case 'wallet':
        return PaymentMethod.wallet.index;
      default:
        return null;
    }
  }

  String? _resolveImage(String? imageKey, String? localAssetPath) {
    if (imageKey != null && imageKey.isNotEmpty) {
      return '${ApiEndpoints.catalogImageBase}$imageKey';
    }
    if (localAssetPath != null && localAssetPath.isNotEmpty) {
      return localAssetPath;
    }
    return null;
  }

  void _trackOrphan(String? oldPath, String? newPath, List<String> sink) {
    if (oldPath == null || oldPath == newPath) return;
    if (oldPath.startsWith('assets/') ||
        oldPath.startsWith('http://') ||
        oldPath.startsWith('https://')) {
      return;
    }
    sink.add(oldPath);
  }

  Map<String, T> _byUuid<T>(List<T> items, String Function(T) uuidOf) {
    final out = <String, T>{};
    for (final item in items) {
      final uuid = uuidOf(item);
      if (uuid.isNotEmpty) out[uuid] = item;
    }
    return out;
  }

  T? _firstByUuid<T>(List<T> items, String Function(T) uuidOf, String uuid) {
    for (final item in items) {
      if (uuidOf(item) == uuid) return item;
    }
    return null;
  }
}
