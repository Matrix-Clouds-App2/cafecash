import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_constants.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_text.dart';

class TreasuryBalanceCard extends StatelessWidget {
  const TreasuryBalanceCard({
    super.key,
    required this.balance,
    this.openingBalance = 0,
  });

  final double balance;

  final double openingBalance;

  @override
  Widget build(BuildContext context) {
    final secondary = AppColors.secondaryColor.themeColor;

    return Container(
      width: double.infinity,
      padding: 28.paddingAll,
      decoration: BoxDecoration(
        color: secondary,
        borderRadius:
            BorderRadius.circular(AppConstants.cardBorderRadius.r + 4),
      ),
      child: Column(
        children: [
          Container(
            width: 56.w,
            height: 56.w,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Icon(
              Icons.account_balance_wallet_rounded,
              color: secondary,
              size: 26.sp,
            ),
          ),
          16.height,
          AppText(
            LocaleKeys.treasury_currentBalance.tr(),
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.white.withValues(alpha: 0.8),
          ),
          10.height,
          AppText(
            '${balance.toStringAsFixed(0)} ${LocaleKeys.common_currency.tr()}',
            fontSize: 32,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
          if (openingBalance > 0) ...[
            10.height,
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: AppText(
                LocaleKeys.treasury_includesOpeningBalance.tr(namedArgs: {
                  'amount': openingBalance.toStringAsFixed(0),
                  'currency': LocaleKeys.common_currency.tr(),
                }),
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: Colors.white.withValues(alpha: 0.9),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
