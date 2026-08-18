import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../extensions/extensions.dart';
import '../utils/app_colors.dart';
import 'app_text.dart';

class NavBarItem {
  const NavBarItem({required this.labelKey, required this.icon});

  final String labelKey;
  final IconData icon;
}

class CoffeeCashNavBar extends StatelessWidget {
  const CoffeeCashNavBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  final List<NavBarItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.textPrimaryColor.themeColor.withOpacity(0.01);
    final textPrimary = AppColors.textPrimaryColor.themeColor;
    final inactive = AppColors.textSecondaryColor.themeColor;

    return Container(
      height: 75.h + MediaQuery.of(context).padding.bottom,
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom, top: 5.h),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor.themeColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        children: List.generate(items.length, (i) {
          final item = items[i];
          final isActive = i == currentIndex;

          return Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => onTap(i),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding:
                        EdgeInsets.symmetric(horizontal: 14.w, vertical: 5.h),
                    decoration: BoxDecoration(
                      color: isActive
                          ? primary.withValues(alpha: 0.09)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(
                      item.icon,
                      size: 22.sp,
                      color: isActive ? textPrimary : inactive,
                    ),
                  ),
                  3.height,
                  AppText(
                    item.labelKey.tr(),
                    fontSize: 10.sp,
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                    color: isActive ? textPrimary : inactive,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                  3.height,
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
