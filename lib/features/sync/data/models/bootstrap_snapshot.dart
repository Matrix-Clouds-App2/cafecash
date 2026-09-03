import 'dart:convert';

import 'package:archive/archive.dart';

import '../../../orders/data/models/order_entity.dart';

class BootstrapSnapshot {
  const BootstrapSnapshot({
    required this.categories,
    required this.menuItems,
    required this.customers,
    required this.orders,
    required this.treasury,
    required this.payments,
    required this.deletedCustomers,
    required this.deletedCategories,
    required this.deletedMenuItems,
  });

  final List<BsCategory> categories;
  final List<BsMenuItem> menuItems;
  final List<BsCustomer> customers;
  final List<BsOrder> orders;
  final List<BsTreasuryTxn> treasury;
  final List<BsPayment> payments;
  final List<String> deletedCustomers;
  final List<String> deletedCategories;
  final List<String> deletedMenuItems;

  bool get isEmpty =>
      categories.isEmpty &&
      menuItems.isEmpty &&
      customers.isEmpty &&
      orders.isEmpty &&
      treasury.isEmpty &&
      payments.isEmpty &&
      deletedCustomers.isEmpty &&
      deletedCategories.isEmpty &&
      deletedMenuItems.isEmpty;

  static BootstrapSnapshot fromResponseBytes(List<int> bytes) {
    List<int> jsonBytes;
    try {
      jsonBytes = GZipDecoder().decodeBytes(bytes);
    } catch (_) {
      jsonBytes = bytes;
    }

    final decoded = jsonDecode(utf8.decode(jsonBytes));
    final root = decoded is Map<String, dynamic> && decoded['data'] is Map
        ? (decoded['data'] as Map).cast<String, dynamic>()
        : (decoded as Map).cast<String, dynamic>();

    return fromJson(root);
  }

  static BootstrapSnapshot fromJson(Map<String, dynamic> json) {
    List<Map<String, dynamic>> rows(String key) =>
        ((json[key] as List?) ?? const [])
            .whereType<Map>()
            .map((e) => e.cast<String, dynamic>())
            .toList();

    List<String> uuids(String key) => ((json[key] as List?) ?? const [])
        .map((e) => e.toString())
        .where((e) => e.isNotEmpty)
        .toList();

    final orders = <BsOrder>[
      ...rows('paid_orders').map((e) => BsOrder.fromJson(e, OrderStatus.paid)),
      ...rows('cancelled_orders')
          .map((e) => BsOrder.fromJson(e, OrderStatus.cancelled)),
      ...rows('deferred_orders')
          .map((e) => BsOrder.fromJson(e, OrderStatus.deferred)),
    ];

    return BootstrapSnapshot(
      categories: rows('categories').map(BsCategory.fromJson).toList(),
      menuItems: rows('menu_items').map(BsMenuItem.fromJson).toList(),
      customers: rows('customers').map(BsCustomer.fromJson).toList(),
      orders: orders,
      treasury:
          rows('treasury_transactions').map(BsTreasuryTxn.fromJson).toList(),
      payments: rows('payments').map(BsPayment.fromJson).toList(),
      deletedCustomers: uuids('deleted_customers'),
      deletedCategories: uuids('deleted_categories'),
      deletedMenuItems: uuids('deleted_menu_items'),
    );
  }
}

double? _money(dynamic value) =>
    value == null ? null : double.tryParse(value.toString());

int _qty(dynamic value) => (double.tryParse('${value ?? 0}') ?? 0).round();

DateTime? _date(dynamic value) =>
    value == null ? null : DateTime.tryParse(value.toString())?.toLocal();

class BsCategory {
  const BsCategory({
    required this.uuid,
    required this.name,
    required this.sortOrder,
    required this.isDefault,
    required this.imageKey,
    required this.localAssetPath,
  });

  final String uuid;
  final String name;
  final int sortOrder;
  final bool isDefault;
  final String? imageKey;
  final String? localAssetPath;

  factory BsCategory.fromJson(Map<String, dynamic> json) => BsCategory(
        uuid: json['uuid']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
        sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
        isDefault: json['is_default'] == true,
        imageKey: json['image_url']?.toString() ?? json['image_key']?.toString(),
        localAssetPath: json['local_asset_path']?.toString(),
      );
}

class BsMenuItem {
  const BsMenuItem({
    required this.uuid,
    required this.categoryUuid,
    required this.name,
    required this.price,
    required this.sortOrder,
    required this.isDefault,
    required this.imageKey,
    required this.localAssetPath,
  });

  final String uuid;
  final String categoryUuid;
  final String name;
  final double price;
  final int sortOrder;
  final bool isDefault;
  final String? imageKey;
  final String? localAssetPath;

  factory BsMenuItem.fromJson(Map<String, dynamic> json) => BsMenuItem(
        uuid: json['uuid']?.toString() ?? '',
        categoryUuid: json['category_uuid']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
        price: _money(json['price']) ?? 0,
        sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
        isDefault: json['is_default'] == true,
        imageKey: json['image_url']?.toString() ?? json['image_key']?.toString(),
        localAssetPath: json['local_asset_path']?.toString(),
      );
}

class BsCustomer {
  const BsCustomer({
    required this.uuid,
    required this.name,
    required this.phone,
  });

  final String uuid;
  final String name;
  final String phone;

  factory BsCustomer.fromJson(Map<String, dynamic> json) => BsCustomer(
        uuid: json['uuid']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
        phone: json['phone']?.toString() ?? '',
      );
}

class BsOrder {
  const BsOrder({
    required this.uuid,
    required this.status,
    required this.customerUuid,
    required this.tableUuid,
    required this.tableNumber,
    required this.total,
    required this.paymentMethod,
    required this.paidAmount,
    required this.cancelReason,
    required this.createdAt,
    required this.closedAt,
    required this.items,
  });

  final String uuid;
  final OrderStatus status;
  final String? customerUuid;
  final String? tableUuid;
  final int tableNumber;
  final double total;
  final String? paymentMethod;
  final double paidAmount;
  final String? cancelReason;
  final DateTime? createdAt;
  final DateTime? closedAt;
  final List<BsOrderItem> items;

  factory BsOrder.fromJson(Map<String, dynamic> json, OrderStatus status) {
    final location = (json['location'] as Map?)?.cast<String, dynamic>();
    return BsOrder(
      uuid: json['uuid']?.toString() ?? '',
      status: status,
      customerUuid: json['customer_uuid']?.toString(),
      tableUuid: location?['table_uuid']?.toString(),
      tableNumber: (location?['number'] as num?)?.toInt() ?? 0,
      total: _money(json['total']) ?? 0,
      paymentMethod: json['payment_method']?.toString(),
      paidAmount: _money(json['paid_amount']) ?? 0,
      cancelReason: json['cancel_reason']?.toString(),
      createdAt: _date(json['created_at_client']),
      closedAt: _date(json['closed_at_client']),
      items: ((json['items'] as List?) ?? const [])
          .whereType<Map>()
          .map((e) => BsOrderItem.fromJson(e.cast<String, dynamic>()))
          .toList(),
    );
  }
}

class BsOrderItem {
  const BsOrderItem({
    required this.uuid,
    required this.menuItemUuid,
    required this.name,
    required this.price,
    required this.quantity,
  });

  final String uuid;
  final String? menuItemUuid;
  final String name;
  final double price;
  final int quantity;

  factory BsOrderItem.fromJson(Map<String, dynamic> json) => BsOrderItem(
        uuid: json['uuid']?.toString() ?? '',
        menuItemUuid: json['menu_item_uuid']?.toString(),
        name: json['name']?.toString() ?? '',
        price: _money(json['price']) ?? 0,
        quantity: _qty(json['quantity']),
      );
}

class BsTreasuryTxn {
  const BsTreasuryTxn({
    required this.uuid,
    required this.employeeId,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.isIncome,
    required this.createdAt,
  });

  final String uuid;
  final int? employeeId;
  final String title;
  final String subtitle;
  final double amount;
  final bool isIncome;
  final DateTime? createdAt;

  factory BsTreasuryTxn.fromJson(Map<String, dynamic> json) => BsTreasuryTxn(
        uuid: json['uuid']?.toString() ?? '',
        employeeId: (json['employee_id'] as num?)?.toInt(),
        title: json['title']?.toString() ?? '',
        subtitle: json['subtitle']?.toString() ?? '',
        amount: _money(json['amount']) ?? 0,
        isIncome: json['is_income'] == true,
        createdAt: _date(json['created_at_client']),
      );
}

class BsPayment {
  const BsPayment({
    required this.uuid,
    required this.orderUuid,
    required this.type,
    required this.paymentMethod,
    required this.amount,
    required this.paidAt,
  });

  final String uuid;
  final String? orderUuid;
  final String? type;
  final String? paymentMethod;
  final double amount;
  final DateTime? paidAt;

  factory BsPayment.fromJson(Map<String, dynamic> json) => BsPayment(
        uuid: json['uuid']?.toString() ?? '',
        orderUuid: json['order_uuid']?.toString(),
        type: json['type']?.toString(),
        paymentMethod: json['payment_method']?.toString(),
        amount: _money(json['amount']) ?? 0,
        paidAt: _date(json['paid_at']),
      );
}
