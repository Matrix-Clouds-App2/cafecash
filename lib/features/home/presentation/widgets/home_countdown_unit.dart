import 'package:coffee_shop/core/utils/app_colors.dart';
import 'package:coffee_shop/core/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A single countdown box showing [value] (e.g. days, hours, minutes,
/// seconds) with its [label] below.
///
/// Styled with a white background, gold/amber border, and primary-green
/// number matching the design screenshots.
class HomeCountdownUnit extends StatelessWidget {
  const HomeCountdownUnit({
    super.key,
    required this.value,
    required this.label,
  });

  final int value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;
    final gold = AppColors.accentGold.themeColor;

    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 7.h, horizontal: 4.w),
        decoration: BoxDecoration(
          color: Colors.orange.shade50.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.orange.shade200, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: gold.withValues(alpha: 0.10),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppText(
              value.toString().padLeft(2, '0'),
              fontSize: 22.sp,
              fontWeight: FontWeight.w800,
              color: primary,
              textAlign: TextAlign.center,
            ),
            // 4.verticalSpace,
            AppText(
              label,
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondaryColor.themeColor,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

