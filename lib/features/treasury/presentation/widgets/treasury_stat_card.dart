import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_constants.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/custom_tap_effect.dart';

class TreasuryStatCard extends StatelessWidget {
  const TreasuryStatCard({
    super.key,
    required this.icon,
    required this.color,
    required this.label,
    this.value,
    this.backgroundColor,
    this.onTap,
  });

  final IconData icon;
  final Color color;
  final String label;
  final String? value;
  final Color? backgroundColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return CustomTapEffect(
      onTap: onTap ?? () {},
      child: Container(
        width: double.infinity,
        padding: 18.paddingAll,
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.cardColor.themeColor,
          borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius.r),
        ),
        child: Column(
          children: [
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.14),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 22.sp),
            ),
            12.height,
            AppText(
              label,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimaryColor.themeColor,
            ),
            if (value != null) ...[
              6.height,
              AppText(
                value!,
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
