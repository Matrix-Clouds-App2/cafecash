import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/custom_tap_effect.dart';
import '../../../orders/data/models/order_location_kind.dart';

class PaymentsTabBar extends StatelessWidget {
  const PaymentsTabBar({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final OrderLocationKind selected;
  final ValueChanged<OrderLocationKind> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: 4.paddingAll,
      decoration: BoxDecoration(
        color: AppColors.surfaceColor.themeColor,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.dividerColor.themeColor),
      ),
      child: Row(
        children: [
          Expanded(
            child: _Segment(
              label: LocaleKeys.nav_hall.tr(),
              icon: Icons.table_bar_rounded,
              color: AppColors.secondaryColor.themeColor,
              isSelected: selected == OrderLocationKind.table,
              onTap: () => onChanged(OrderLocationKind.table),
            ),
          ),
          8.width,
          Expanded(
            child: _Segment(
              label: LocaleKeys.nav_matches.tr(),
              icon: Icons.event_seat_rounded,
              color: AppColors.accentGold.themeColor,
              isSelected: selected == OrderLocationKind.seat,
              onTap: () => onChanged(OrderLocationKind.seat),
            ),
          ),
        ],
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({
    required this.label,
    required this.icon,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return CustomTapEffect(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.symmetric(vertical: 9.h),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.transparent,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16.sp,
              color: isSelected
                  ? Colors.white
                  : AppColors.textSecondaryColor.themeColor,
            ),
            6.width,
            AppText(
              label,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: isSelected
                  ? Colors.white
                  : AppColors.textSecondaryColor.themeColor,
            ),
          ],
        ),
      ),
    );
  }
}
