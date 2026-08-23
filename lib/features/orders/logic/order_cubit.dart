import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/app_constants.dart';
import '../../../core/utils/app_overlay.dart';
import '../../../core/utils/locale_keys.dart';
import '../../customers/data/models/customer_entity.dart';
import '../../items/data/items_repo.dart';
import '../../items/data/models/category_entity.dart';
import '../../items/data/models/menu_item_entity.dart';
import '../../treasury/data/treasury_repo.dart';
import '../data/models/order_entity.dart';
import '../data/models/order_item_entity.dart';
import '../data/models/order_location_kind.dart';
import '../data/orders_repo.dart';

part 'order_state.dart';

typedef LocationStatusSync = void Function({
  required bool occupied,
  int drinkCount,
  double price,
});

class OrderCubit extends Cubit<OrderState> {
  OrderCubit(
    this._ordersRepo,
    this._itemsRepo,
    this._treasuryRepo,
  ) : super(const OrderInitial());

  final OrdersRepo _ordersRepo;
  final ItemsRepo _itemsRepo;
  final TreasuryRepo _treasuryRepo;

  late int _locationId;
  late int _locationNumber;
  late OrderLocationKind _kind;
  late String _locationLabel;
  late LocationStatusSync _syncStatus;

  List<CategoryEntity> _categories = [];
  List<MenuItemEntity> _allItems = [];
  String _query = '';

  void load({
    required int locationId,
    required int locationNumber,
    required OrderLocationKind kind,
    required String locationLabel,
    required LocationStatusSync syncStatus,
  }) {
    _locationId = locationId;
    _locationNumber = locationNumber;
    _kind = kind;
    _locationLabel = locationLabel;
    _syncStatus = syncStatus;

    emit(const OrderLoading());
    try {
      _categories = _itemsRepo.getCategories();
      _allItems = [
        for (final category in _categories)
          ..._itemsRepo.getItemsByCategory(category.id),
      ];
      _emit();
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }

  void search(String query) {
    _query = query;
    _emit();
  }

  void setQuantity(MenuItemEntity item, int quantity) {
    try {
      _ordersRepo.setQuantity(
        locationId: _locationId,
        locationNumber: _locationNumber,
        kind: _kind,
        menuItem: item,
        quantity: quantity < 0 ? 0 : quantity,
        createdBy: kUserModel?.name,
      );
      _syncLocationAndEmit();
    } catch (e) {
      AppOverlay.showError(e.toString());
    }
  }

  void increment(MenuItemEntity item) =>
      setQuantity(item, _quantityOf(item.id) + 1);

  void decrement(MenuItemEntity item) =>
      setQuantity(item, _quantityOf(item.id) - 1);

  void incrementItem(OrderItemEntity item) =>
      _setOrderItemQuantity(item, item.quantity + 1);

  void decrementItem(OrderItemEntity item) =>
      _setOrderItemQuantity(item, item.quantity - 1);

  void removeItem(OrderItemEntity item) => _setOrderItemQuantity(item, 0);

  void _setOrderItemQuantity(OrderItemEntity item, int quantity) {
    try {
      _ordersRepo.setOrderItemQuantity(item, quantity < 0 ? 0 : quantity);
      _syncLocationAndEmit();
    } catch (e) {
      AppOverlay.showError(e.toString());
    }
  }

  void payFull(PaymentMethod method) {
    final order = _ordersRepo.getActiveOrder(_locationId, _kind);
    if (order == null) return;
    try {
      final total = _ordersRepo.orderTotal(order.id);

      _ordersRepo.payFull(order, method);
      _syncStatus(occupied: false);
      _treasuryRepo.add(
        title: LocaleKeys.treasury_receiveCash.tr(),
        subtitle: LocaleKeys.treasury_orderPaymentSubtitle.tr(namedArgs: {
          'location': '$_locationLabel $_locationNumber',
          'order': '${order.id}',
        }),
        amount: total,
        isIncome: true,
        paymentMethod: method,
        orderId: order.id,
        createdBy: kUserModel?.name,
      );
      emit(const OrderClosed());
    } catch (e) {
      AppOverlay.showError(e.toString());
    }
  }

  void collectPartialPayment(
    Map<OrderItemEntity, int> selections,
    PaymentMethod method,
  ) {
    final order = _ordersRepo.getActiveOrder(_locationId, _kind);
    if (order == null || selections.isEmpty) return;
    try {
      final amount = selections.entries
          .fold<double>(0, (sum, entry) => sum + entry.key.price * entry.value);

      _ordersRepo.collectPartial(order: order, selections: selections);
      _treasuryRepo.add(
        title: LocaleKeys.treasury_receiveCash.tr(),
        subtitle: LocaleKeys.treasury_partialPaymentSubtitle.tr(namedArgs: {
          'location': '$_locationLabel $_locationNumber',
          'order': '${order.id}',
        }),
        amount: amount,
        isIncome: true,
        paymentMethod: method,
        orderId: order.id,
        createdBy: kUserModel?.name,
      );

      final stillOpen = _ordersRepo.getActiveOrder(_locationId, _kind) != null;
      if (stillOpen) {
        _syncLocationAndEmit();
      } else {
        _syncStatus(occupied: false);
        emit(const OrderClosed());
      }
    } catch (e) {
      AppOverlay.showError(e.toString());
    }
  }

  void deferOrder(CustomerEntity customer) {
    final order = _ordersRepo.getActiveOrder(_locationId, _kind);
    if (order == null) return;
    try {
      _ordersRepo.deferOrder(order: order, customer: customer);
      _syncStatus(occupied: false);
      emit(const OrderClosed());
    } catch (e) {
      AppOverlay.showError(e.toString());
    }
  }

  void cancelOrder(String reason) {
    final order = _ordersRepo.getActiveOrder(_locationId, _kind);
    if (order == null) return;
    try {
      _ordersRepo.cancel(order, reason: reason);
      _syncStatus(occupied: false);
      emit(const OrderClosed());
    } catch (e) {
      AppOverlay.showError(e.toString());
    }
  }

  int _quantityOf(int menuItemId) {
    final order = _ordersRepo.getActiveOrder(_locationId, _kind);
    if (order == null) return 0;
    for (final item in _ordersRepo.getItems(order.id)) {
      if (item.menuItemId == menuItemId) return item.quantity;
    }
    return 0;
  }

  void _syncLocationAndEmit() {
    final order = _ordersRepo.getActiveOrder(_locationId, _kind);
    if (order == null) {
      _syncStatus(occupied: false);
    } else {
      _syncStatus(
        occupied: true,
        drinkCount: _ordersRepo.orderItemsCount(order.id),
        price: _ordersRepo.orderTotal(order.id),
      );
    }
    _emit();
  }

  void _emit() {
    final order = _ordersRepo.getActiveOrder(_locationId, _kind);
    final orderItems =
        order == null ? <OrderItemEntity>[] : _ordersRepo.getItems(order.id);
    final quantities = {
      for (final item in orderItems) item.menuItemId: item.quantity,
    };

    final query = _query.trim().toLowerCase();
    final filteredItems = query.isEmpty
        ? null
        : _allItems
            .where((item) =>
                item.name.toLowerCase().contains(query) ||
                (item.nameEn ?? '').toLowerCase().contains(query))
            .toList();

    emit(OrderSuccess(
      locationNumber: _locationNumber,
      locationLabel: _locationLabel,
      kind: _kind,
      categories: _categories,
      allItems: _allItems,
      filteredItems: filteredItems,
      orderItems: orderItems,
      quantities: quantities,
      total: order == null ? 0 : _ordersRepo.orderTotal(order.id),
    ));
  }
}
