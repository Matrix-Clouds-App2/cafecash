import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/logic/connectivity_cubit.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_constants.dart';
import '../../../../core/utils/convert_helper.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/custom_tap_effect.dart';
import '../../data/models/shift_entity.dart';

class ShiftHistoryCard extends StatelessWidget {
  const ShiftHistoryCard({
    super.key,
    required this.shift,
    required this.onTap,
    this.onRetryUpload,
  });

  final ShiftEntity shift;
  final VoidCallback onTap;
  final VoidCallback? onRetryUpload;

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;
    final success = AppColors.successColor.themeColor;
    final warning = AppColors.warningColor.themeColor;
    final closedAt = shift.closedAt;
    final isOnline = context.watch<ConnectivityCubit>().state is ConnectivityOnline;

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
                    color: shift.synced
                        ? success.withValues(alpha: 0.12)
                        : warning.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        shift.synced
                            ? Icons.cloud_done_rounded
                            : Icons.cloud_off_rounded,
                        size: 12.sp,
                        color: shift.synced ? success : warning,
                      ),
                      4.width,
                      AppText(
                        shift.synced
                            ? LocaleKeys.sync_syncedBadge.tr()
                            : LocaleKeys.sync_notSyncedBadge.tr(),
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: shift.synced ? success : warning,
                      ),
                    ],
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
            if (!shift.synced && onRetryUpload != null && isOnline && !kIsGuest) ...[
              10.height,
              CustomTapEffect(
                onTap: onRetryUpload,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  decoration: BoxDecoration(
                    color: primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.cloud_upload_outlined,
                          size: 15.sp, color: primary),
                      6.width,
                      AppText(
                        LocaleKeys.sync_retryUpload.tr(),
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: primary,
                      ),
                    ],
                  ),
                ),
              ),
            ],
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
