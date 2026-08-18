part of 'order_cubit.dart';

sealed class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object?> get props => [];
}

final class OrderInitial extends OrderState {
  const OrderInitial();
}

final class OrderLoading extends OrderState {
  const OrderLoading();
}

final class OrderSuccess extends OrderState {
  final int locationNumber;
  final String locationLabel;
  final OrderLocationKind kind;

  final List<CategoryEntity> categories;
  final List<MenuItemEntity> allItems;

  final List<MenuItemEntity>? filteredItems;

  final List<OrderItemEntity> orderItems;

  final Map<int, int> quantities;

  final double total;

  const OrderSuccess({
    required this.locationNumber,
    required this.locationLabel,
    required this.kind,
    required this.categories,
    required this.allItems,
    required this.filteredItems,
    required this.orderItems,
    required this.quantities,
    required this.total,
  });

  @override
  List<Object?> get props => [
        locationNumber,
        locationLabel,
        kind,
        categories,
        allItems,
        filteredItems,
        orderItems,
        quantities,
        total,
      ];
}

final class OrderError extends OrderState {
  final String message;

  const OrderError(this.message);

  @override
  List<Object?> get props => [message];
}

final class OrderClosed extends OrderState {
  const OrderClosed();
}
