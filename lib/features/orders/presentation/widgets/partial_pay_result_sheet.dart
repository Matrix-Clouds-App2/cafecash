import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_bottom_sheet.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/custom_tap_effect.dart';

enum PartialPayResult { keepOpen, deferRemainder }

class PartialPayResultSheet {
  PartialPayResultSheet._();

  static Future<PartialPayResult?> show(BuildContext context) {
    return AppBottomSheet.show<PartialPayResult>(
      context,
      title: LocaleKeys.orders_partialPayResultTitle.tr(),
      child: const _PartialPayResultOptions(),
    );
  }
}

class _PartialPayResultOptions extends StatelessWidget {
  const _PartialPayResultOptions();

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;
    final accent = AppColors.accentGold.themeColor;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppText(
          LocaleKeys.orders_partialPayResultMessage.tr(),
          fontSize: 13,
          color: AppColors.textSecondaryColor.themeColor,
        ),
        16.height,
        _ResultTile(
          icon: Icons.table_bar_rounded,
          color: accent,
          label: LocaleKeys.orders_keepOpenOption.tr(),
          onTap: () => Navigator.pop(context, PartialPayResult.keepOpen),
        ),
        10.height,
        _ResultTile(
          icon: Icons.person_outline_rounded,
          color: accent,
          label: LocaleKeys.orders_deferRemainderOption.tr(),
          onTap: () => Navigator.pop(context, PartialPayResult.deferRemainder),
        ),
      ],
    );
  }
}

class _ResultTile extends StatelessWidget {
  const _ResultTile({
    required this.icon,
    required this.color,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return CustomTapEffect(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: color.withValues(alpha: 0.25)),
        ),
        child: Row(
          children: [
            Container(
              width: 40.r,
              height: 40.r,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.14),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 20.sp),
            ),
            12.width,
            Expanded(
              child: AppText(
                label,
                fontSize: 14.5,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
