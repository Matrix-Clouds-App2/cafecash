import 'package:app_base/core/extensions/extensions.dart';
import 'package:app_base/core/utils/app_colors.dart';
import 'package:app_base/core/widgets/app_text.dart';
import 'package:app_base/core/widgets/custom_tap_effect.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

/// Data model for one quick-access tile.
class QuickAccessItem {
  const QuickAccessItem({
    required this.icon,
    this.image,
    required this.label,
    required this.onTap,
    this.accentColor = AppColors.primaryColor,
  });

  final IconData icon;
  final String? image;
  final String label;
  final VoidCallback onTap;
  final ColorModel accentColor;
}

/// A single tappable card in the Quick Access grid.
///
/// White background · subtle border · icon on top · label below.
class HomeQuickAccessItem extends StatelessWidget {
  const HomeQuickAccessItem({super.key, required this.item});

  final QuickAccessItem item;

  @override
  Widget build(BuildContext context) {
    final accent = item.accentColor.themeColor;

    return CustomTapEffect(
      onTap: item.onTap,
      child: Container(
        margin: 4.paddingHorizontal,
        width: 85,
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 8.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: const Color(0xFFE8EBE7)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(10.r),
              ),
              padding: 5.paddingAll + 1.paddingHorizontal,
              child: (item.image != null)
                  ? SvgPicture.asset(
                      item.image!,
                      width: 20.w,
                      height: 20.h,
                      color: accent,
                    )
                  : Icon(item.icon, color: accent, size: 20.sp),
            ),
            5.verticalSpace,
            AppText(
              item.label,
              fontSize: 10.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF17212B),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
