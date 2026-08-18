import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_constants.dart';
import '../../../../core/utils/convert_helper.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_text.dart';
import '../../data/models/shift_entity.dart';

class ShiftPeriodCard extends StatelessWidget {
  const ShiftPeriodCard({super.key, required this.shift});

  final ShiftEntity shift;

  String _format(DateTime? dateTime) {
    if (dateTime == null) return '';
    return ConvertHelper.formatDateTime(
      dateTime.toIso8601String(),
      includeDate: true,
      includeTime: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;

    return Container(
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
          _Row(
            icon: Icons.play_circle_outline_rounded,
            color: primary,
            label: LocaleKeys.shift_startedAt.tr(),
            value: _format(shift.startedAt),
          ),
          10.height,
          _Row(
            icon: Icons.stop_circle_outlined,
            color: shift.closedAt == null
                ? AppColors.accentGold.themeColor
                : AppColors.errorColor.themeColor,
            label: LocaleKeys.shift_endedAt.tr(),
            value: shift.closedAt == null
                ? LocaleKeys.shift_ongoing.tr()
                : _format(shift.closedAt),
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final Color color;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18.sp, color: color),
        8.width,
        AppText(
          label,
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondaryColor.themeColor,
        ),
        const Spacer(),
        AppText(
          value,
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimaryColor.themeColor,
        ),
      ],
    );
  }
}
