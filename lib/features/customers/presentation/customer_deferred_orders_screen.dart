import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/di/injection.dart';
import '../../../core/extensions/extensions.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_constants.dart';
import '../../../core/utils/app_overlay.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/app_empty.dart';
import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/cancel_reason_sheet.dart';
import '../../orders/data/models/order_entity.dart';
import '../../orders/data/orders_repo.dart';
import '../../orders/presentation/widgets/payment_method_sheet.dart';
import '../../shift/data/shift_repo.dart';
import '../../treasury/data/treasury_repo.dart';
import '../data/models/customer_entity.dart';
import 'widgets/deferred_order_card.dart';

class CustomerDeferredOrdersScreen extends StatefulWidget {
  const CustomerDeferredOrdersScreen({super.key, required this.customer});

  final CustomerEntity customer;

  @override
  State<CustomerDeferredOrdersScreen> createState() =>
      _CustomerDeferredOrdersScreenState();
}

class _CustomerDeferredOrdersScreenState
    extends State<CustomerDeferredOrdersScreen> {
  final _ordersRepo = getIt<OrdersRepo>();
  late List<OrderEntity> _orders;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  void _refresh() {
    setState(() {
      _orders = _ordersRepo.getDeferredOrdersForCustomer(widget.customer.id);
    });
  }

  bool _requireActiveShift() {
    if (getIt<ShiftRepo>().getActiveShift() != null) return true;
    AppOverlay.showError(LocaleKeys.shift_noActiveShift.tr());
    return false;
  }

  Future<void> _collect(OrderEntity order) async {
    if (!_requireActiveShift()) return;

    final method = await PaymentMethodSheet.show(context);
    if (method == null) return;

    final total = _ordersRepo.orderTotal(order.id);
    final methodLabel = method == PaymentMethod.cash
        ? LocaleKeys.orders_cash.tr()
        : LocaleKeys.orders_wallet.tr();

    _ordersRepo.payFull(order, method);
    getIt<TreasuryRepo>().add(
      title: LocaleKeys.treasury_receiveCash.tr(),
      subtitle: LocaleKeys.treasury_deferredCollectionSubtitle.tr(namedArgs: {
        'customer': widget.customer.name,
        'order': '${order.id}',
        'method': methodLabel,
      }),
      amount: total,
      isIncome: true,
      createdBy: kUserModel?.name,
    );
    _refresh();
  }

  Future<void> _confirmWriteOff(OrderEntity order) async {
    if (!_requireActiveShift()) return;

    final reason = await CancelReasonSheet.show(
      context,
      title: LocaleKeys.customers_writeOffTitle.tr(),
      message: LocaleKeys.customers_writeOffMessage.tr(),
      confirmLabel: LocaleKeys.customers_writeOffAction.tr(),
    );
    if (reason == null) return;
    _ordersRepo.cancel(order, reason: reason);
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;
    final accent = AppColors.accentGold.themeColor;
    final totalOwed = _orders.fold<double>(
        0, (sum, order) => sum + _ordersRepo.orderTotal(order.id));

    return Scaffold(
      backgroundColor: AppColors.surfaceColor.themeColor,
      appBar: AppBar(
          title: Text(widget.customer.name),
          backgroundColor: primary,
          foregroundColor: AppColors.textPrimaryColor.themeColor),
      body: Column(
        children: [
          Padding(
            padding: 16.paddingAll,
            child: Container(
              width: double.infinity,
              padding: 16.paddingAll,
              decoration: BoxDecoration(
                color: AppColors.cardColor.themeColor,
                borderRadius:
                    BorderRadius.circular(AppConstants.cardBorderRadius.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 48.w,
                    height: 48.w,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: primary.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child:
                        Icon(Icons.phone_outlined, color: primary, size: 20.sp),
                  ),
                  12.width,
                  Expanded(
                    child: AppText(
                      widget.customer.phone,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimaryColor.themeColor,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      AppText(
                        LocaleKeys.customers_totalOwed.tr(),
                        fontSize: 11.5,
                        color: AppColors.textSecondaryColor.themeColor,
                      ),
                      2.height,
                      AppText(
                        '${totalOwed.toStringAsFixed(0)} ${LocaleKeys.common_currency.tr()}',
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: accent,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: _orders.isEmpty
                ? AppEmpty(
                    message: LocaleKeys.customers_noDeferredOrders.tr(),
                    icon: Icons.receipt_long_outlined,
                  )
                : ListView.separated(
                    padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
                    itemCount: _orders.length,
                    separatorBuilder: (_, __) => 14.height,
                    itemBuilder: (_, i) {
                      final order = _orders[i];
                      return DeferredOrderCard(
                        order: order,
                        items: _ordersRepo.getItems(order.id),
                        total: _ordersRepo.orderTotal(order.id),
                        onCollect: () => _collect(order),
                        onCancel: () => _confirmWriteOff(order),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
