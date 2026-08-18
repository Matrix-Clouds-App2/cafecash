import 'package:app_base/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../extensions/extensions.dart';
import 'app_text.dart';

/// A single labeled row used inside bottom-sheet option menus — an icon in
/// a tinted circle plus a label (e.g. edit/delete, camera/gallery choices).
class SheetOptionTile extends StatelessWidget {
  const SheetOptionTile({
    super.key,
    required this.icon,
    required this.label,
    this.labelColor,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;
  final Color? labelColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.29),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: labelColor ?? AppColors.textPrimaryColor.themeColor,
          width: 1.w,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40.r,
            height: 40.r,
            decoration: BoxDecoration(
              color: labelColor != null
                  ? labelColor?.withValues(alpha: 0.14)
                  : color.withValues(alpha: 0.14),
              shape: BoxShape.circle,
            ),
            child: Icon(icon,
                color: labelColor ?? AppColors.textPrimaryColor.themeColor,
                size: 20.sp),
          ),
          12.width,
          AppText(
            label,
            fontSize: 14.5,
            fontWeight: FontWeight.w700,
            color: labelColor ?? AppColors.textPrimaryColor.themeColor,
          ),
        ],
      ),
    );
  }
}
