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
import '../../data/models/paid_invoice.dart';

class PaymentsInvoiceCard extends StatelessWidget {
  const PaymentsInvoiceCard(
      {super.key, required this.invoice, required this.onTap});

  final PaidInvoice invoice;
  final VoidCallback onTap;

  Color _kindColor() => invoice.kind == OrderLocationKind.table
      ? AppColors.secondaryColor.themeColor
      : AppColors.secondaryColor.themeColor;

  IconData _kindIcon() => invoice.kind == OrderLocationKind.table
      ? Icons.table_bar_rounded
      : Icons.event_seat_rounded;

  String _kindLabel() => invoice.kind == OrderLocationKind.table
      ? LocaleKeys.hall_tableLabel.tr()
      : LocaleKeys.matches_seatLabel.tr();

  @override
  Widget build(BuildContext context) {
    final success = AppColors.successColor.themeColor;

    return CustomTapEffect(onTap: onTap, child: _buildCard(success));
  }

  Widget _buildCard(Color success) {
    final kindColor = _kindColor();

    return Container(
      width: double.infinity,
      padding: 16.paddingAll,
      decoration: BoxDecoration(
        color: AppColors.cardColor.themeColor,
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius.r),
        border: Border.all(color: kindColor.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: success,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: AppText(
                  LocaleKeys.payments_paidBadge.tr(),
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              Row(
                children: [
                  if (invoice.paymentMethod != null) ...[
                    _PaymentMethodPill(method: invoice.paymentMethod!),
                    8.width,
                  ],
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
                    decoration: BoxDecoration(
                      color: success.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: AppText(
                      '#${invoice.number}',
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: success,
                    ),
                  ),
                ],
              ),
            ],
          ),
          16.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _InfoChunk(
                icon: invoice.paymentMethod == PaymentMethod.wallet
                    ? Icons.account_balance_wallet_outlined
                    : Icons.payments_outlined,
                color: AppColors.secondaryColor.themeColor,
                value: '${invoice.amount.toStringAsFixed(0)} '
                    '${LocaleKeys.common_currency.tr()}',
              ),
              _InfoChunk(
                icon: Icons.local_cafe_outlined,
                color: AppColors.textPrimaryColor.themeColor,
                value:
                    '${invoice.itemsCount} ${LocaleKeys.payments_items.tr()}',
              ),
              _InfoChunk(
                icon: _kindIcon(),
                color: kindColor,
                value: '${_kindLabel()} ${invoice.locationNumber}',
              ),
            ],
          ),
          16.height,
          Divider(color: AppColors.dividerColor.themeColor, height: 1),
          10.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.chevron_left_rounded,
                  size: 18.sp, color: AppColors.textSecondaryColor.themeColor),
              AppText(
                invoice.dateTime,
                fontSize: 12,
                color: AppColors.textSecondaryColor.themeColor,
              ),
              Icon(Icons.access_time_rounded,
                  size: 16.sp, color: AppColors.textSecondaryColor.themeColor),
            ],
          ),
        ],
      ),
    );
  }
}

class _PaymentMethodPill extends StatelessWidget {
  const _PaymentMethodPill({required this.method});

  final PaymentMethod method;

  @override
  Widget build(BuildContext context) {
    final color = AppColors.secondaryColor.themeColor;
    final isCash = method == PaymentMethod.cash;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isCash
                ? Icons.payments_outlined
                : Icons.account_balance_wallet_outlined,
            size: 13.sp,
            color: color,
          ),
          4.width,
          AppText(
            isCash
                ? LocaleKeys.orders_cash.tr()
                : LocaleKeys.orders_wallet.tr(),
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ],
      ),
    );
  }
}

class _InfoChunk extends StatelessWidget {
  const _InfoChunk(
      {required this.icon, required this.color, required this.value});

  final IconData icon;
  final Color color;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 18.sp, color: color),
        6.height,
        AppText(
          value,
          fontSize: 12.5,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimaryColor.themeColor,
        ),
      ],
    );
  }
}
