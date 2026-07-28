import 'package:easy_localization/easy_localization.dart';
import 'package:app_base/core/utils/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/utils/app_colors.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/app_text.dart';
import '../../home/presentation/home_screen.dart';
import '../../more/presentation/more_screen.dart';

class LayoutScreen extends StatefulWidget {
  const LayoutScreen({super.key, this.currentPage = 0});

  final int currentPage;

  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen> {
  late int _currentIndex;

  static final _screens = [
    const HomeScreen(),
    const MoreScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentPage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: _CustomNavBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
      ),
    );
  }
}

// ── Nav item descriptor ───────────────────────────────────────────────────────

class _NavItem {
  const _NavItem({required this.labelKey, required this.icon});
  final String labelKey;
  final String icon;
}

final _navItems = [
  const _NavItem(labelKey: LocaleKeys.nav_home,      icon: AppImages.iconsHome),
  const _NavItem(labelKey: LocaleKeys.nav_more,      icon: AppImages.iconsMore),
];

// ── Custom nav bar ────────────────────────────────────────────────────────────

class _CustomNavBar extends StatelessWidget {
  const _CustomNavBar({required this.currentIndex, required this.onTap});

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;

    return Container(
      height: 75.h + MediaQuery.of(context).padding.bottom,
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom,top: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        children: List.generate(_navItems.length, (i) {
          final item = _navItems[i];
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
                    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 5.h),
                    decoration: BoxDecoration(
                      color: isActive
                          ? primary.withValues(alpha: 0.12)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: SvgPicture.asset(
                      item.icon,
                      width: 22.w,
                      height: 22.w,
                      colorFilter: ColorFilter.mode(
                        isActive ? primary : const Color(0xFF9E9E9E),
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  3.height,
                  AppText(
                    item.labelKey.tr(),
                    fontSize: 10.sp,
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                    color: isActive ? primary : const Color(0xFF9E9E9E),
                    maxLines: 2,
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
