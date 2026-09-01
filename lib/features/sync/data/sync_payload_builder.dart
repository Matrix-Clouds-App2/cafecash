import 'dart:io';

import 'package:uuid/uuid.dart';

import '../../../core/storage/object_box/entities/pending_deletion_entity.dart';
import '../../../core/storage/pending_deletion_repo.dart';
import '../../../core/utils/app_constants.dart';
import '../../customers/data/customers_repo.dart';
import '../../hall/data/hall_repo.dart';
import '../../items/data/items_repo.dart';
import '../../items/data/models/category_entity.dart';
import '../../items/data/models/menu_item_entity.dart';
import '../../matches/data/matches_repo.dart';
import '../../orders/data/models/order_entity.dart';
import '../../orders/data/models/order_location_kind.dart';
import '../../orders/data/orders_repo.dart';
import '../../shift/data/models/shift_entity.dart';
import '../../shift/logic/shift_window.dart';
import '../../treasury/data/treasury_repo.dart';
import 'models/sync_image_ref.dart';
import 'models/sync_payload.dart';

class SyncPayloadBuilder {
  SyncPayloadBuilder({
    required OrdersRepo ordersRepo,
    required TreasuryRepo treasuryRepo,
    required CustomersRepo customersRepo,
    required ItemsRepo itemsRepo,
    required HallRepo hallRepo,
    required MatchesRepo matchesRepo,
    required PendingDeletionRepo pendingDeletionRepo,
  })  : _ordersRepo = ordersRepo,
        _treasuryRepo = treasuryRepo,
        _customersRepo = customersRepo,
        _itemsRepo = itemsRepo,
        _hallRepo = hallRepo,
        _matchesRepo = matchesRepo,
        _pendingDeletionRepo = pendingDeletionRepo;

  final OrdersRepo _ordersRepo;
  final TreasuryRepo _treasuryRepo;
  final CustomersRepo _customersRepo;
  final ItemsRepo _itemsRepo;
  final HallRepo _hallRepo;
  final MatchesRepo _matchesRepo;
  final PendingDeletionRepo _pendingDeletionRepo;

  SyncPayload build(ShiftEntity shift, {required String syncUuid}) {
    bool inWindow(DateTime? at) => ShiftWindow.contains(shift, at);

    final allCustomers = _customersRepo.getAll();
    final allCategories = _itemsRepo.getCategories();
    final allItems = _itemsRepo.getAllItems();

    final customerUuidById = {for (final c in allCustomers) c.id: c.uuid};
    final categoryUuidById = {for (final c in allCategories) c.id: c.uuid};
    final menuItemUuidById = {for (final i in allItems) i.id: i.uuid};

    final tableUuidById = {for (final t in _hallRepo.getTables()) t.id: t.uuid};
    final seatUuidById = {for (final s in _matchesRepo.getSeats()) s.id: s.uuid};

    final unsyncedCustomers =
        allCustomers.where((c) => !c.synced).toList();
    final unsyncedCategories =
        allCategories.where((c) => !c.synced).toList();
    final unsyncedItems = allItems.where((i) => !i.synced).toList();

    final imageRefs = <SyncImageRef>[];
    final categoriesJson = unsyncedCategories
        .map((c) => _categoryJson(c, imageRefs))
        .toList();
    final itemsJson = unsyncedItems
        .map((i) => _menuItemJson(i, categoryUuidById, imageRefs))
        .toList();

    final windowedPaid =
        _ordersRepo.getPaidOrders().where((o) => inWindow(o.closedAt));
    final windowedCancelled =
        _ordersRepo.getCancelledOrders().where((o) => inWindow(o.closedAt));
    final windowedDeferred =
        _ordersRepo.getDeferredOrders().where((o) => inWindow(o.closedAt));

    final freshPaid = windowedPaid.where((o) => !o.synced).toList();
    final collectedOrders = windowedPaid.where((o) => o.synced).toList();
    final freshCancelled = windowedCancelled.where((o) => !o.synced).toList();
    final freshDeferred = windowedDeferred.where((o) => !o.synced).toList();

    String? tableUuidFor(OrderEntity order) =>
        order.locationKindEnum == OrderLocationKind.table
            ? tableUuidById[order.tableId]
            : seatUuidById[order.tableId];

    final paidOrdersJson = freshPaid
        .map((o) => _orderJson(o, customerUuidById, menuItemUuidById,
            tableUuidFor(o)))
        .toList();
    final cancelledOrdersJson = freshCancelled
        .map((o) => _orderJson(o, customerUuidById, menuItemUuidById,
            tableUuidFor(o)))
        .toList();
    final deferredOrdersJson = freshDeferred
        .map((o) => _orderJson(o, customerUuidById, menuItemUuidById,
            tableUuidFor(o)))
        .toList();

    final paymentsJson = <Map<String, dynamic>>[];
    for (final order in collectedOrders) {
      final collectionTransactions = _treasuryRepo
          .getByOrderId(order.id)
          .where((t) => inWindow(t.createdAt));
      for (final transaction in collectionTransactions) {
        paymentsJson.add({
          'uuid': const Uuid().v4(),
          'order_uuid': order.uuid,
          'shift_uuid': shift.uuid,
          'type': 'debt_collection',
          'payment_method': transaction.paymentMethodEnum?.name ?? 'cash',
          'amount': _money(transaction.amount),
          'paid_at': _iso(transaction.createdAt),
        });
      }
    }

    final treasuryJson = _treasuryRepo
        .getAll()
        .where((t) => inWindow(t.createdAt))
        .map((t) => {
              'uuid': t.uuid,
              'shift_uuid': shift.uuid,
              'employee_id': t.createdById,
              'title': t.title,
              'subtitle': t.subtitle,
              'amount': _money(t.amount),
              'is_income': t.isIncome,
              'created_at_client': _iso(t.createdAt),
            })
        .toList();

    final deletedCustomers = _pendingDeletionRepo
        .getByType(PendingDeletionType.customer)
        .map((e) => e.entityUuid)
        .toList();
    final deletedCategories = _pendingDeletionRepo
        .getByType(PendingDeletionType.category)
        .map((e) => e.entityUuid)
        .toList();
    final deletedMenuItems = _pendingDeletionRepo
        .getByType(PendingDeletionType.menuItem)
        .map((e) => e.entityUuid)
        .toList();

    final json = {
      'sync_uuid': syncUuid,
      'cashier': {'employee_id': kUserModel?.id},
      'shift': {
        'uuid': shift.uuid,
        'employee_id': kUserModel?.id,
        'opening_balance': shift.openingBalance.toStringAsFixed(2),
        'closing_balance': shift.closingBalance?.toStringAsFixed(2),
        'started_at': _iso(shift.startedAt),
        'closed_at': _iso(shift.closedAt),
      },
      'customers': unsyncedCustomers
          .map((c) => {
                'uuid': c.uuid,
                'name': c.name,
                'phone': c.phone,
              })
          .toList(),
      'categories': categoriesJson,
      'menu_items': itemsJson,
      'paid_orders': paidOrdersJson,
      'cancelled_orders': cancelledOrdersJson,
      'deferred_orders': deferredOrdersJson,
      'payments': paymentsJson,
      'treasury_transactions': treasuryJson,
      'deleted_customers': deletedCustomers,
      'deleted_categories': deletedCategories,
      'deleted_menu_items': deletedMenuItems,
    };

    return SyncPayload(
      json: json,
      imageRefs: imageRefs,
      customersToMarkSynced: unsyncedCustomers,
      categoriesToMarkSynced: unsyncedCategories,
      itemsToMarkSynced: unsyncedItems,
      ordersToMarkSynced: [...freshPaid, ...freshCancelled, ...freshDeferred],
      deletionIdsToConsume: _pendingDeletionRepo.getAll().map((e) => e.id).toList(),
    );
  }

  Map<String, dynamic> _categoryJson(
      CategoryEntity category, List<SyncImageRef> imageRefs) {
    final isAsset = _isAssetPath(category.imagePath);
    final imageKey =
        isAsset ? null : _imageKeyFor(category.uuid, category.imagePath);
    if (imageKey != null) {
      imageRefs.add(SyncImageRef(imageKey: imageKey, localPath: category.imagePath!));
    }
    return {
      'uuid': category.uuid,
      'name': category.name,
      'sort_order': category.sortOrder,
      'is_active': true,
      'is_default': category.isDefault,
      'image_key': imageKey,
      'local_asset_path': isAsset ? category.imagePath : null,
    };
  }

  Map<String, dynamic> _menuItemJson(
    MenuItemEntity item,
    Map<int, String> categoryUuidById,
    List<SyncImageRef> imageRefs,
  ) {
    final isAsset = _isAssetPath(item.imagePath);
    final imageKey = isAsset ? null : _imageKeyFor(item.uuid, item.imagePath);
    if (imageKey != null) {
      imageRefs.add(SyncImageRef(imageKey: imageKey, localPath: item.imagePath!));
    }
    return {
      'uuid': item.uuid,
      'category_uuid': categoryUuidById[item.categoryId],
      'name': item.name,
      'price': _money(item.price),
      'sort_order': item.sortOrder,
      'is_active': true,
      'is_default': item.isDefault,
      'image_key': imageKey,
      'local_asset_path': isAsset ? item.imagePath : null,
    };
  }

  Map<String, dynamic> _orderJson(
    OrderEntity order,
    Map<int, String> customerUuidById,
    Map<int, String> menuItemUuidById,
    String? tableUuid,
  ) {
    final items = _ordersRepo.getItems(order.id);
    final total = _ordersRepo.orderTotal(order.id);

    final json = <String, dynamic>{
      'uuid': order.uuid,
      'customer_uuid':
          order.customerId == null ? null : customerUuidById[order.customerId],
      'location': {
        'table_uuid': tableUuid,
        'number': order.tableNumber,
      },
      'subtotal': _money(total),
      'discount_amount': _money(0),
      'total': _money(total),
      'created_at_client': _iso(order.createdAt),
      'closed_at_client': _iso(order.closedAt),
      'items': items
          .map((item) => {
                'uuid': item.uuid,
                'menu_item_uuid': menuItemUuidById[item.menuItemId],
                'name': item.name,
                'price': _money(item.price),
                'quantity': _quantity(item.quantity),
                'line_total': _money(item.price * item.quantity),
              })
          .toList(),
    };

    switch (order.statusEnum) {
      case OrderStatus.paid:
        json['payment_method'] = order.paymentMethodEnum?.name ?? 'cash';
        json['paid_amount'] = _money(total);
        break;
      case OrderStatus.cancelled:
        json['cancel_reason'] = order.cancelReason;
        break;
      case OrderStatus.deferred:
      case OrderStatus.active:
      case OrderStatus.rolledOver:
        break;
    }

    return json;
  }

  static const _acceptedImageExtensions = {'jpg', 'jpeg', 'png', 'webp'};

  bool _isAssetPath(String? imagePath) =>
      imagePath != null && imagePath.startsWith('assets/');

  String? _imageKeyFor(String uuid, String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) return null;
    if (!imagePath.contains('.')) return null;
    final ext = imagePath.split('.').last.toLowerCase();
    if (!_acceptedImageExtensions.contains(ext)) return null;
    if (!File(imagePath).existsSync()) return null;
    return '$uuid.$ext';
  }

  String? _iso(DateTime? dateTime) => dateTime?.toUtc().toIso8601String();

  String _money(num value) => value.toStringAsFixed(2);

  String _quantity(num value) => value.toStringAsFixed(3);
}
