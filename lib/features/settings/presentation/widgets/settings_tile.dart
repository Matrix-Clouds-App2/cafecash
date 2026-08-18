import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_constants.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/custom_tap_effect.dart';

class SettingsItem {
  const SettingsItem({
    required this.icon,
    required this.label,
    required this.subLabel,
    required this.color,
    required this.onTap,
    this.locked = false,
  });

  final IconData icon;
  final String label;
  final String subLabel;
  final Color color;
  final VoidCallback onTap;
  final bool locked;
}

class SettingsTile extends StatelessWidget {
  const SettingsTile({super.key, required this.item});

  final SettingsItem item;

  @override
  Widget build(BuildContext context) {
    final tileColor =
        item.locked ? AppColors.disabledColor.themeColor : item.color;

    return CustomTapEffect(
      onTap: item.onTap,
      child: Container(
        margin: 12.paddingBottom,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: AppColors.cardColor.themeColor,
          borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44.r,
              height: 44.r,
              decoration: BoxDecoration(
                color: tileColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(item.icon, color: tileColor, size: 22.sp),
            ),
            12.width,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      AppText(
                        item.label,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimaryColor.themeColor,
                      ),
                      if (item.locked) ...[
                        8.width,
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: AppColors.disabledColor.themeColor
                                .withValues(alpha: 0.14),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: AppText(
                            LocaleKeys.settings_comingSoonBadge.tr(),
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: AppColors.disabledColor.themeColor,
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (item.subLabel.isNotEmpty) ...[
                    3.height,
                    AppText(
                      item.subLabel,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textSecondaryColor.themeColor,
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              item.locked
                  ? Icons.lock_outline_rounded
                  : Icons.arrow_forward_ios_rounded,
              size: item.locked ? 17.sp : 15.sp,
              color: AppColors.textSecondaryColor.themeColor,
            ),
          ],
        ),
      ),
    );
  }
}
