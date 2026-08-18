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
import '../../data/models/shift_entity.dart';

class ShiftHistoryCard extends StatelessWidget {
  const ShiftHistoryCard({super.key, required this.shift, required this.onTap});

  final ShiftEntity shift;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;
    final success = AppColors.successColor.themeColor;
    final closedAt = shift.closedAt;

    return CustomTapEffect(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: 16.paddingAll,
        decoration: BoxDecoration(
          color: AppColors.cardColor.themeColor,
          borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius.r),
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
                Row(
                  children: [
                    Icon(Icons.task_alt_rounded, size: 18.sp, color: primary),
                    6.width,
                    AppText(
                      closedAt == null
                          ? ''
                          : ConvertHelper.formatDateTime(
                              closedAt.toIso8601String(),
                              includeDate: true,
                              includeTime: true,
                            ),
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimaryColor.themeColor,
                    ),
                  ],
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AppColors.dividerColor.themeColor,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: AppText(
                    LocaleKeys.shift_closedBadge.tr(),
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondaryColor.themeColor,
                  ),
                ),
              ],
            ),
            10.height,
            Divider(height: 1, color: AppColors.dividerColor.themeColor),
            10.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _Stat(
                  label: LocaleKeys.shift_openingBalance.tr(),
                  value: shift.openingBalance,
                  color: AppColors.secondaryColor.themeColor,
                ),
                _Stat(
                  label: LocaleKeys.shift_closingBalance.tr(),
                  value: shift.closingBalance ?? 0,
                  color: success,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value, required this.color});

  final String label;
  final double value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppText(
          label,
          fontSize: 11.5,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondaryColor.themeColor,
        ),
        4.height,
        AppText(
          '${value.toStringAsFixed(0)} ${LocaleKeys.common_currency.tr()}',
          fontSize: 14,
          fontWeight: FontWeight.w800,
          color: color,
        ),
      ],
    );
  }
}
