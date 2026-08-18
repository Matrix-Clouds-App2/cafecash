import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../orders/data/models/order_entity.dart';
import '../../orders/data/orders_repo.dart';
import '../../shift/data/models/shift_entity.dart';
import '../../shift/data/shift_repo.dart';

part 'payments_state.dart';

class PaymentsCubit extends Cubit<PaymentsState> {
  PaymentsCubit(this._ordersRepo, this._shiftRepo)
      : super(const PaymentsInitial());

  final OrdersRepo _ordersRepo;
  final ShiftRepo _shiftRepo;
  StreamSubscription<List<OrderEntity>>? _subscription;

  void fetch() {
    emit(const PaymentsLoading());
    _subscription?.cancel();

    final activeShift = _shiftRepo.getActiveShift();

    _subscription = _ordersRepo.watchPaidOrders().listen(
          (orders) =>
              emit(PaymentsSuccess(_scopedToShift(orders, activeShift))),
          onError: (Object e) => emit(PaymentsError(e.toString())),
        );
  }

  List<OrderEntity> _scopedToShift(
      List<OrderEntity> orders, ShiftEntity? shift) {
    final start = shift?.startedAt;
    if (start == null) return orders;
    return orders
        .where((order) =>
            order.closedAt != null && !order.closedAt!.isBefore(start))
        .toList();
  }

  int itemsCount(OrderEntity order) => _ordersRepo.orderItemsCount(order.id);

  double total(OrderEntity order) => _ordersRepo.orderTotal(order.id);

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
