import '../../../core/storage/object_box/local_box.dart';
import '../../../core/storage/object_box/object_box_storage.dart';
import '../../customers/data/models/customer_entity.dart';
import '../../items/data/models/menu_item_entity.dart';
import 'models/order_entity.dart';
import 'models/order_item_entity.dart';
import 'models/order_location_kind.dart';

T? _firstOrNull<T>(Iterable<T> items) => items.isEmpty ? null : items.first;

class OrdersRepo {
  OrdersRepo({required ObjectBoxStorage storage})
      : _orderBox = storage.box<OrderEntity>(),
        _itemBox = storage.box<OrderItemEntity>();

  final LocalBox<OrderEntity> _orderBox;
  final LocalBox<OrderItemEntity> _itemBox;

  OrderEntity? getActiveOrder(int locationId, OrderLocationKind kind) {
    return _firstOrNull(_orderBox.getAll().where((order) =>
        order.tableId == locationId &&
        order.locationKindEnum == kind &&
        order.statusEnum == OrderStatus.active));
  }

  List<OrderItemEntity> getItems(int orderId) {
    return _itemBox.getAll().where((item) => item.orderId == orderId).toList()
      ..sort((a, b) => a.id.compareTo(b.id));
  }

  double orderTotal(int orderId) => getItems(orderId)
      .fold<double>(0, (sum, item) => sum + item.price * item.quantity);

  int orderItemsCount(int orderId) =>
      getItems(orderId).fold<int>(0, (sum, item) => sum + item.quantity);

  List<OrderEntity> getPaidOrders() => _paidFrom(_orderBox.getAll());

  Stream<List<OrderEntity>> watchPaidOrders() =>
      _orderBox.watchAll().map(_paidFrom);

  List<OrderEntity> _paidFrom(List<OrderEntity> orders) {
    final paid =
        orders.where((order) => order.statusEnum == OrderStatus.paid).toList();
    paid.sort((a, b) =>
        (b.closedAt ?? DateTime(0)).compareTo(a.closedAt ?? DateTime(0)));
    return paid;
  }

  void setQuantity({
    required int locationId,
    required int locationNumber,
    required OrderLocationKind kind,
    required MenuItemEntity menuItem,
    required int quantity,
    String? createdBy,
  }) {
    var order = getActiveOrder(locationId, kind);
    order ??= OrderEntity(
      tableId: locationId,
      tableNumber: locationNumber,
      locationKind: kind.index,
      createdAt: DateTime.now(),
      createdBy: createdBy,
    );
    if (order.id == 0) {
      order.id = _orderBox.put(order);
    }

    final existing = _firstOrNull(
        getItems(order.id).where((item) => item.menuItemId == menuItem.id));

    if (quantity <= 0) {
      if (existing != null) _itemBox.remove(existing.id);
    } else if (existing != null) {
      existing.quantity = quantity;
      _itemBox.put(existing);
    } else {
      _itemBox.put(OrderItemEntity(
        orderId: order.id,
        menuItemId: menuItem.id,
        name: menuItem.name,
        price: menuItem.price,
        imagePath: menuItem.imagePath,
        quantity: quantity,
      ));
    }

    _deleteOrderIfEmpty(order.id);
  }

  void setOrderItemQuantity(OrderItemEntity item, int quantity) {
    if (quantity <= 0) {
      _itemBox.remove(item.id);
    } else {
      item.quantity = quantity;
      _itemBox.put(item);
    }
    _deleteOrderIfEmpty(item.orderId);
  }

  void _deleteOrderIfEmpty(int orderId) {
    if (getItems(orderId).isEmpty) _orderBox.remove(orderId);
  }

  void payFull(OrderEntity order, PaymentMethod method) {
    order
      ..statusEnum = OrderStatus.paid
      ..paymentMethodEnum = method
      ..closedAt = DateTime.now();
    _orderBox.put(order);
  }

  void cancel(OrderEntity order, {required String reason}) {
    order
      ..statusEnum = OrderStatus.cancelled
      ..closedAt = DateTime.now()
      ..cancelReason = reason;
    _orderBox.put(order);
  }

  void collectPartial({
    required OrderEntity order,
    required Map<OrderItemEntity, int> selections,
  }) {
    for (final entry in selections.entries) {
      final item = entry.key;
      final collectedQuantity = entry.value;
      if (collectedQuantity <= 0) continue;
      if (collectedQuantity >= item.quantity) {
        _itemBox.remove(item.id);
      } else {
        item.quantity -= collectedQuantity;
        _itemBox.put(item);
      }
    }
    _deleteOrderIfEmpty(order.id);
  }

  void deferOrder(
      {required OrderEntity order, required CustomerEntity customer}) {
    order
      ..statusEnum = OrderStatus.deferred
      ..customerId = customer.id
      ..customerName = customer.name
      ..closedAt = DateTime.now();
    _orderBox.put(order);
  }

  List<OrderEntity> getDeferredOrders() => _deferredFrom(_orderBox.getAll());

  List<OrderEntity> getDeferredOrdersForCustomer(int customerId) =>
      getDeferredOrders()
          .where((order) => order.customerId == customerId)
          .toList();

  List<OrderEntity> _deferredFrom(List<OrderEntity> orders) {
    final deferred = orders
        .where((order) => order.statusEnum == OrderStatus.deferred)
        .toList();
    deferred.sort((a, b) =>
        (b.closedAt ?? DateTime(0)).compareTo(a.closedAt ?? DateTime(0)));
    return deferred;
  }

  double deferredBalance(int customerId) => getDeferredOrdersForCustomer(
        customerId,
      ).fold<double>(0, (sum, order) => sum + orderTotal(order.id));

  List<OrderEntity> getCancelledOrders() => _cancelledFrom(_orderBox.getAll());

  List<OrderEntity> _cancelledFrom(List<OrderEntity> orders) {
    final cancelled = orders
        .where((order) => order.statusEnum == OrderStatus.cancelled)
        .toList();
    cancelled.sort((a, b) =>
        (b.closedAt ?? DateTime(0)).compareTo(a.closedAt ?? DateTime(0)));
    return cancelled;
  }
}
