import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/di/injection.dart';
import '../../../core/extensions/extensions.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_constants.dart';
import '../../../core/utils/app_overlay.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/app_confirm_dialog.dart';
import '../../../core/widgets/app_empty.dart';
import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/cancel_reason_sheet.dart';
import '../../../core/widgets/payment_method_sheet.dart';
import '../../orders/data/models/order_entity.dart';
import '../../orders/data/orders_repo.dart';
import '../../shift/data/shift_repo.dart';
import '../../treasury/data/treasury_repo.dart';
import '../data/customers_repo.dart';
import '../data/models/customer_entity.dart';
import 'widgets/customer_form_sheet.dart';
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

    if (!kWalletPaymentEnabled) {
      AppConfirmDialog.show(
        context,
        icon: Icons.check_circle_outline_rounded,
        iconColor: AppColors.successColor.themeColor,
        title: LocaleKeys.orders_confirmPaymentTitle.tr(),
        message: LocaleKeys.orders_confirmPaymentMessage.tr(),
        confirmLabel: LocaleKeys.orders_payButton.tr(),
        confirmColor: AppColors.successColor.themeColor,
        onConfirm: () {
          Navigator.pop(context);
          _completeCollect(order, PaymentMethod.cash);
        },
      );
      return;
    }

    final method = await PaymentMethodSheet.show(context);
    if (method == null) return;
    _completeCollect(order, method);
  }

  void _completeCollect(OrderEntity order, PaymentMethod method) {
    final total = _ordersRepo.orderTotal(order.id);

    _ordersRepo.payFull(order, method);
    getIt<TreasuryRepo>().add(
      title: LocaleKeys.treasury_receiveCash.tr(),
      subtitle: LocaleKeys.treasury_deferredCollectionSubtitle.tr(namedArgs: {
        'customer': widget.customer.name,
        'order': '${order.id}',
      }),
      amount: total,
      isIncome: true,
      paymentMethod: method,
      orderId: order.id,
      createdBy: kUserModel?.name,
      createdById: kUserModel?.id,
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

  void _openEditCustomer() {
    CustomerFormSheet.show(
      context,
      customer: widget.customer,
      onSubmit: _confirmEditCustomer,
    );
  }

  void _confirmEditCustomer(String name, String phone) {
    AppConfirmDialog.show(
      context,
      icon: Icons.edit_outlined,
      iconColor: AppColors.primaryColor.themeColor,
      title: LocaleKeys.customers_confirmEditTitle.tr(),
      message: LocaleKeys.customers_confirmEditMessage.tr(),
      confirmLabel: LocaleKeys.common_save.tr(),
      onConfirm: () {
        Navigator.pop(context);
        _applyEditCustomer(name, phone);
      },
    );
  }

  void _applyEditCustomer(String name, String phone) {
    final repo = getIt<CustomersRepo>();
    if (repo.phoneExists(phone, excludingId: widget.customer.id)) {
      AppOverlay.showError(LocaleKeys.customers_phoneExists.tr());
      return;
    }
    widget.customer
      ..name = name
      ..phone = phone;
    repo.update(widget.customer);
    setState(() {});
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
        foregroundColor: AppColors.textPrimaryColor.themeColor,
        actions: [
          IconButton(
            onPressed: _openEditCustomer,
            icon: const Icon(Icons.edit_outlined),
          ),
        ],
      ),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          widget.customer.name,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimaryColor.themeColor,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        2.height,
                        AppText(
                          widget.customer.phone,
                          fontSize: 12,
                          color: AppColors.textSecondaryColor.themeColor,
                        ),
                      ],
                    ),
                  ),
                  12.width,
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
