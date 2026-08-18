import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_constants.dart';
import '../../../../core/utils/convert_helper.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_text.dart';
import '../../data/models/treasury_transaction_entity.dart';

class TreasuryTransactionTile extends StatelessWidget {
  const TreasuryTransactionTile({super.key, required this.transaction});

  final TreasuryTransactionEntity transaction;

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
            ],
          ),
        ],
      ),
    );
  }
}
