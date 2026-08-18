import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_constants.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/custom_tap_effect.dart';
import '../../../orders/data/models/order_entity.dart';
import '../../../orders/data/models/order_location_kind.dart';

class CancelledOrderCard extends StatelessWidget {
  const CancelledOrderCard({
    super.key,
    required this.order,
    required this.amount,
    required this.itemsCount,
    required this.dateTime,
    required this.onTap,
  });

  final OrderEntity order;
  final double amount;
  final int itemsCount;
  final String dateTime;
  final VoidCallback onTap;

  IconData get _kindIcon => order.locationKindEnum == OrderLocationKind.table
      ? Icons.table_bar_rounded
      : Icons.event_seat_rounded;

  String get _kindLabel => order.locationKindEnum == OrderLocationKind.table
      ? LocaleKeys.hall_tableLabel.tr()
      : LocaleKeys.matches_seatLabel.tr();

  @override
  Widget build(BuildContext context) {
    final error = AppColors.errorColor.themeColor;
    final reason = order.cancelReason ?? '';

    return CustomTapEffect(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: 16.paddingAll,
        decoration: BoxDecoration(
          color: AppColors.cardColor.themeColor,
          borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius.r),
          border: Border.all(color: error.withValues(alpha: 0.3)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
                  decoration: BoxDecoration(
                    color: error,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: AppText(
                    LocaleKeys.orders_cancelledBadge.tr(),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                Row(
                  children: [
                    if (order.customerId != null) ...[
                      Icon(Icons.account_balance_outlined,
                          size: 13.sp, color: error),
                      4.width,
                      AppText(
                        LocaleKeys.orders_cancelledFromDeferred.tr(),
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        color: error,
                      ),
                      8.width,
                    ],
                    Icon(_kindIcon, size: 15.sp, color: error),
                    4.width,
                    AppText(
                      '$_kindLabel ${order.tableNumber}',
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimaryColor.themeColor,
                    ),
                  ],
                ),
              ],
            ),
            10.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(
                  '${amount.toStringAsFixed(0)} ${LocaleKeys.common_currency.tr()}',
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimaryColor.themeColor,
                ),
                AppText(
                  '$itemsCount ${LocaleKeys.payments_items.tr()}',
                  fontSize: 12,
                  color: AppColors.textSecondaryColor.themeColor,
                ),
              ],
            ),
            if (reason.isNotEmpty) ...[
              8.height,
              AppText(
                reason,
                fontSize: 12,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                color: AppColors.textSecondaryColor.themeColor,
              ),
            ],
            10.height,
            Divider(color: AppColors.dividerColor.themeColor, height: 1),
            8.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.chevron_left_rounded,
                    size: 18.sp,
                    color: AppColors.textSecondaryColor.themeColor),
                AppText(
                  dateTime,
                  fontSize: 12,
                  color: AppColors.textSecondaryColor.themeColor,
                ),
                Icon(Icons.access_time_rounded,
                    size: 16.sp,
                    color: AppColors.textSecondaryColor.themeColor),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
