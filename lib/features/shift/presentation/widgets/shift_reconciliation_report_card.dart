import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_text.dart';
import '../../data/models/shift_reconciliation.dart';
import 'shift_branding_footer.dart';

class ShiftReconciliationReportCard extends StatelessWidget {
  const ShiftReconciliationReportCard({super.key, required this.reconciliation});

  final ShiftReconciliation reconciliation;

  @override
  Widget build(BuildContext context) {
    final isDeficit = reconciliation.isDeficit;
    final accent = isDeficit
        ? AppColors.errorColor.themeColor
        : AppColors.successColor.themeColor;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 28.h),
      decoration: BoxDecoration(
        color: AppColors.cardColor.themeColor,
        borderRadius: BorderRadius.circular(26.r),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: 0.25),
            blurRadius: 26,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 96.w,
            height: 96.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [accent, accent.withValues(alpha: 0.7)],
              ),
              boxShadow: [
                BoxShadow(
                  color: accent.withValues(alpha: 0.45),
                  blurRadius: 22,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Icon(
              isDeficit
                  ? Icons.trending_down_rounded
                  : Icons.trending_up_rounded,
              color: Colors.white,
              size: 50.sp,
            ),
          ),
          20.height,
          AppText(
            isDeficit
                ? LocaleKeys.shift_reconcile_deficitTitle.tr()
                : LocaleKeys.shift_reconcile_surplusTitle.tr(),
            fontSize: 19,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimaryColor.themeColor,
            textAlign: TextAlign.center,
          ),
          8.height,
          AppText(
            '${reconciliation.totalDifference.abs().toStringAsFixed(0)} '
            '${LocaleKeys.common_currency.tr()}',
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: accent,
          ),
          24.height,
          _buildChannelRow(
            icon: Icons.payments_rounded,
            label: LocaleKeys.shift_reconcile_cashChannel.tr(),
            expected: reconciliation.expectedCash,
            actual: reconciliation.actualCash,
          ),
          10.height,
          _buildChannelRow(
            icon: Icons.account_balance_wallet_rounded,
            label: LocaleKeys.shift_reconcile_walletChannel.tr(),
            expected: reconciliation.expectedWallet,
            actual: reconciliation.actualWallet,
          ),
          16.height,
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(color: accent.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                AppText(
                  LocaleKeys.shift_reconcile_totalLabel.tr(),
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimaryColor.themeColor,
                ),
                const Spacer(),
                AppText(
                  _signedAmount(reconciliation.totalDifference),
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: accent,
                ),
              ],
            ),
          ),
          22.height,
          const ShiftBrandingFooter(),
        ],
      ),
    );
  }

  Widget _buildChannelRow({
    required IconData icon,
    required String label,
    required double expected,
    required double actual,
  }) {
    final diff = actual - expected;
    final diffColor = diff < -0.01
        ? AppColors.errorColor.themeColor
        : diff > 0.01
            ? AppColors.successColor.themeColor
            : AppColors.textSecondaryColor.themeColor;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor.themeColor,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16.sp, color: AppColors.textSecondaryColor.themeColor),
              6.width,
              AppText(
                label,
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimaryColor.themeColor,
              ),
              const Spacer(),
              AppText(
                _signedAmount(diff),
                fontSize: 13.5,
                fontWeight: FontWeight.w800,
                color: diffColor,
              ),
            ],
          ),
          6.height,
          AppText(
            '${LocaleKeys.shift_reconcile_expectedLabel.tr()} '
            '${expected.toStringAsFixed(0)} ${LocaleKeys.common_currency.tr()}   •   '
            '${LocaleKeys.shift_reconcile_actualLabel.tr()} '
            '${actual.toStringAsFixed(0)} ${LocaleKeys.common_currency.tr()}',
            fontSize: 10.5,
            color: AppColors.textSecondaryColor.themeColor,
          ),
        ],
      ),
    );
  }

  String _signedAmount(double value) {
    final sign = value > 0.01 ? '+' : (value < -0.01 ? '-' : '');
    return '$sign${value.abs().toStringAsFixed(0)} ${LocaleKeys.common_currency.tr()}';
  }
}
