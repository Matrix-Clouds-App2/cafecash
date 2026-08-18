import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/di/injection.dart';
import '../../../core/extensions/extensions.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/convert_helper.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/app_text.dart';
import '../../customers/data/customers_repo.dart';
import '../../customers/data/models/customer_entity.dart';
import '../../orders/data/models/order_entity.dart';
import '../../orders/data/models/order_location_kind.dart';
import '../../orders/data/orders_repo.dart';
import '../../payments/presentation/widgets/info_pill.dart';
import '../../payments/presentation/widgets/paid_invoice_item_row.dart';

class CancelledOrderDetailsScreen extends StatelessWidget {
  const CancelledOrderDetailsScreen({super.key, required this.order});

  final OrderEntity order;

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;
    final error = AppColors.errorColor.themeColor;
    final repo = getIt<OrdersRepo>();
    final items = repo.getItems(order.id);
    final total = repo.orderTotal(order.id);
    final itemsCount = repo.orderItemsCount(order.id);
    final dateTime = order.closedAt ?? order.createdAt;
    final isSeat = order.locationKindEnum == OrderLocationKind.seat;
    final kindIcon = isSeat ? Icons.event_seat_rounded : Icons.table_bar;
    final kindLabel = isSeat
        ? LocaleKeys.matches_seatLabel.tr()
        : LocaleKeys.hall_tableLabel.tr();

    final isFromDeferred = order.customerId != null;
    CustomerEntity? customer;
    if (isFromDeferred) {
      final matches = getIt<CustomersRepo>()
          .getAll()
          .where((c) => c.id == order.customerId);
      customer = matches.isEmpty ? null : matches.first;
    }

    return Scaffold(
      backgroundColor: AppColors.surfaceColor.themeColor,
      appBar: AppBar(
        title: Column(
          children: [
            AppText(
              '${LocaleKeys.payments_invoiceLabel.tr()} #${order.id}',
              fontSize: 20,
              color: AppColors.textPrimaryColor.themeColor,
            ),
            if (dateTime != null)
              Padding(
                padding: 2.paddingVert,
                child: AppText(
                  ConvertHelper.formatDateTime(
                    dateTime.toIso8601String(),
                    includeDate: true,
                    includeTime: true,
                  ),
                  fontSize: 11,
                  color: Colors.grey.shade900,
                ),
              ),
          ],
        ),
        backgroundColor: primary,
        foregroundColor: AppColors.textPrimaryColor.themeColor,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.fromLTRB(16.w, 20, 16.w, 16.h),
              children: [
                for (final item in items) PaidInvoiceItemRow(item: item),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(kindIcon,
                            color: AppColors.textSecondaryColor.themeColor),
                        5.width,
                        AppText(
                          kindLabel,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondaryColor.themeColor,
                        ),
                      ],
                    ),
                    InfoPill(
                      label: '#${order.tableNumber}',
                      icon: kindIcon,
                      color: error,
                    ),
                  ],
                ),
                if (isFromDeferred) ...[
                  10.height,
                  Divider(color: error.withValues(alpha: 0.2), height: 1),
                  10.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.account_balance_outlined,
                              color: AppColors.textSecondaryColor.themeColor),
                          5.width,
                          AppText(
                            LocaleKeys.orders_cancelledFromDeferred.tr(),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondaryColor.themeColor,
                          ),
                        ],
                      ),
                    ],
                  ),
                  6.height,
                  AppText(
                    order.customerName ?? '',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimaryColor.themeColor,
                  ),
                  if (customer != null) ...[
                    2.height,
                    AppText(
                      customer.phone,
                      fontSize: 12.5,
                      color: AppColors.textSecondaryColor.themeColor,
                    ),
                  ],
                ],
                if ((order.createdBy ?? '').isNotEmpty) ...[
                  10.height,
                  Divider(color: error.withValues(alpha: 0.2), height: 1),
                  10.height,
                  AppText(
                    LocaleKeys.customers_cashierLabel
                        .tr(namedArgs: {'name': order.createdBy!}),
                    fontSize: 12.5,
                    color: AppColors.textSecondaryColor.themeColor,
                  ),
                ],
                if ((order.cancelReason ?? '').isNotEmpty) ...[
                  10.height,
                  Divider(color: error.withValues(alpha: 0.2), height: 1),
                  10.height,
                  AppText(
                    LocaleKeys.orders_cancelReasonLabel.tr(),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondaryColor.themeColor,
                  ),
                  4.height,
                  AppText(
                    order.cancelReason!,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimaryColor.themeColor,
                  ),
                ],
                12.height,
                Divider(color: error.withValues(alpha: 0.2), height: 1),
                10.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.format_list_numbered_rtl_outlined,
                            color: AppColors.textSecondaryColor.themeColor),
                        5.width,
                        AppText(
                          LocaleKeys.payments_items.tr(),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondaryColor.themeColor,
                        ),
                      ],
                    ),
                    AppText(
                      '$itemsCount ${LocaleKeys.payments_items.tr()}',
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimaryColor.themeColor,
                    ),
                  ],
                ),
                10.height,
                Divider(color: error.withValues(alpha: 0.2), height: 1),
                10.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.account_balance_wallet_outlined,
                            color: AppColors.textPrimaryColor.themeColor),
                        5.width,
                        AppText(
                          LocaleKeys.orders_total.tr(),
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimaryColor.themeColor,
                        ),
                      ],
                    ),
                    AppText(
                      '${total.toStringAsFixed(0)} ${LocaleKeys.common_currency.tr()}',
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: error,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
