import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_constants.dart';
import '../../../../core/utils/convert_helper.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../orders/data/models/order_entity.dart';
import '../../../orders/data/models/order_item_entity.dart';
import '../../../payments/presentation/widgets/paid_invoice_item_row.dart';

class DeferredOrderCard extends StatelessWidget {
  const DeferredOrderCard({
    super.key,
    required this.order,
    required this.items,
    required this.total,
    required this.onCollect,
    required this.onCancel,
  });

  final OrderEntity order;
  final List<OrderItemEntity> items;
  final double total;
  final VoidCallback onCollect;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final accent = AppColors.accentGold.themeColor;
    final success = AppColors.successColor.themeColor;
    final error = AppColors.errorColor.themeColor;
    final closedAt = order.closedAt;

    return Container(
      padding: 14.paddingAll,
      decoration: BoxDecoration(
        color: AppColors.surfaceColor.themeColor,
        borderRadius:
            BorderRadius.circular(AppConstants.cardBorderRadius.r + 2),
        border: Border.all(color: accent.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.receipt_long_rounded, size: 16.sp, color: accent),
                  6.width,
                  AppText(
                    '${LocaleKeys.payments_invoiceLabel.tr()} #${order.id}',
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimaryColor.themeColor,
                  ),
                ],
              ),
              if (closedAt != null)
                AppText(
                  ConvertHelper.formatDateTime(
                    closedAt.toIso8601String(),
                    includeDate: true,
                    includeTime: true,
                  ),
                  fontSize: 11,
                  color: AppColors.textSecondaryColor.themeColor,
                ),
            ],
          ),
          if ((order.createdBy ?? '').isNotEmpty) ...[
            4.height,
            AppText(
              LocaleKeys.customers_cashierLabel
                  .tr(namedArgs: {'name': order.createdBy!}),
              fontSize: 11.5,
              color: AppColors.textSecondaryColor.themeColor,
            ),
          ],
          12.height,
          for (final item in items) PaidInvoiceItemRow(item: item),
          Divider(color: AppColors.dividerColor.themeColor, height: 1),
          10.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                LocaleKeys.orders_total.tr(),
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondaryColor.themeColor,
              ),
              AppText(
                '${total.toStringAsFixed(0)} ${LocaleKeys.common_currency.tr()}',
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: accent,
              ),
            ],
          ),
          14.height,
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  height: 40,
                  color: success,
                  textColor: Colors.white,
                  borderColor: Colors.transparent,
                  title: LocaleKeys.customers_collectAction.tr(),
                  onTap: onCollect,
                ),
              ),
              10.width,
              Expanded(
                child: CustomButton(
                  height: 40,
                  isOutlined: true,
                  borderColor: error,
                  textColor: error,
                  title: LocaleKeys.customers_writeOffAction.tr(),
                  onTap: onCancel,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
