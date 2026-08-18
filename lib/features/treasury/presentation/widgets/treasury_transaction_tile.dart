import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_constants.dart';
import '../../../../core/utils/convert_helper.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/custom_tap_effect.dart';
import '../../../../core/widgets/payment_method_sheet.dart';
import '../../../orders/data/models/order_entity.dart';
import '../../data/models/treasury_transaction_entity.dart';

class TreasuryTransactionTile extends StatelessWidget {
  const TreasuryTransactionTile({
    super.key,
    required this.transaction,
    this.onChangePaymentMethod,
  });

  final TreasuryTransactionEntity transaction;
  final ValueChanged<PaymentMethod>? onChangePaymentMethod;

  @override
  Widget build(BuildContext context) {
    final color = transaction.isIncome
        ? AppColors.successColor.themeColor
        : AppColors.errorColor.themeColor;
    final sign = transaction.isIncome ? '+' : '-';

    return Container(
      width: double.infinity,
      padding: 14.paddingAll,
      decoration: BoxDecoration(
        color: AppColors.cardColor.themeColor,
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius.r),
      ),
      child: Row(
        children: [
          Container(
            width: 44.w,
            height: 44.w,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.14),
              shape: BoxShape.circle,
            ),
            child: Icon(
              transaction.isIncome
                  ? Icons.arrow_downward_rounded
                  : Icons.arrow_upward_rounded,
              color: color,
              size: 20.sp,
            ),
          ),
          12.width,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  transaction.title,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimaryColor.themeColor,
                ),
                4.height,
                AppText(
                  transaction.subtitle,
                  fontSize: 12.5,
                  color: AppColors.textSecondaryColor.themeColor,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if ((transaction.createdBy ?? '').isNotEmpty) ...[
                  2.height,
                  AppText(
                    LocaleKeys.treasury_recordedBy
                        .tr(namedArgs: {'name': transaction.createdBy!}),
                    fontSize: 11,
                    color: AppColors.textSecondaryColor.themeColor,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],

              ],
            ),
          ),
          12.width,
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              AppText(
                '$sign${transaction.amount.toStringAsFixed(0)} ${LocaleKeys.common_currency.tr()}',
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: color,
              ),
              4.height,
              AppText(
                ConvertHelper.formatDateTime(
                  transaction.createdAt?.toIso8601String() ?? '',
                  includeDate: false,
                  includeTime: true,
                ),
                fontSize: 11,
                color: AppColors.textSecondaryColor.themeColor,
              ),
              if (kWalletPaymentEnabled && onChangePaymentMethod != null) ...[
                6.height,
                CustomTapEffect(
                  onTap: () async {
                    final method = await PaymentMethodSheet.show(context);
                    if (method != null) onChangePaymentMethod!(method);
                  },
                  child: Container(
                    padding:
                    EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.themeColor
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          transaction.paymentMethodEnum ==
                              PaymentMethod.wallet
                              ? Icons.account_balance_wallet_outlined
                              : Icons.payments_outlined,
                          size: 12.sp,
                          color: AppColors.primaryColor.themeColor,
                        ),
                        4.width,
                        AppText(
                          transaction.paymentMethodEnum ==
                              PaymentMethod.wallet
                              ? LocaleKeys.orders_wallet.tr()
                              : LocaleKeys.orders_cash.tr(),
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryColor.themeColor,
                        ),
                        3.width,
                        Icon(
                          Icons.edit_outlined,
                          size: 11.sp,
                          color: AppColors.primaryColor.themeColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
