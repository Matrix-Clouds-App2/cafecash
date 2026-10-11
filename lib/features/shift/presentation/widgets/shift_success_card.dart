import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_text.dart';
import '../../data/models/shift_summary.dart';
import 'shift_branding_footer.dart';

class ShiftSuccessCard extends StatefulWidget {
  const ShiftSuccessCard({super.key, required this.summary});

  final ShiftSummary summary;

  @override
  State<ShiftSuccessCard> createState() => _ShiftSuccessCardState();
}

class _ShiftSuccessCardState extends State<ShiftSuccessCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _badgeScale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _badgeScale = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final summary = widget.summary;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 28.h),
      decoration: BoxDecoration(
        color: AppColors.cardColor.themeColor,
        borderRadius: BorderRadius.circular(26.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.accentGold.themeColor.withValues(alpha: 0.3),
            blurRadius: 26,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ScaleTransition(
            scale: _badgeScale,
            child: Container(
              width: 96.w,
              height: 96.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.accentGold.themeColor,
                    AppColors.lightAccentColor.themeColor,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accentGold.themeColor.withValues(alpha: 0.45),
                    blurRadius: 22,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Icon(
                Icons.emoji_events_rounded,
                color: Colors.white,
                size: 50.sp,
              ),
            ),
          ),
          20.height,
          AppText(
            LocaleKeys.shift_success_title.tr(),
            fontSize: 21,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimaryColor.themeColor,
            textAlign: TextAlign.center,
          ),
          8.height,
          AppText(
            LocaleKeys.shift_success_subtitle.tr(),
            fontSize: 13.5,
            height: 1.5,
            color: AppColors.textSecondaryColor.themeColor,
            textAlign: TextAlign.center,
          ),
          24.height,
          Container(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            decoration: BoxDecoration(
              color: AppColors.surfaceColor.themeColor,
              borderRadius: BorderRadius.circular(18.r),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildStat(
                    icon: Icons.savings_rounded,
                    label: LocaleKeys.treasury_totalIncome.tr(),
                    value:
                        '${summary.totalIncome.toStringAsFixed(0)} ${LocaleKeys.common_currency.tr()}',
                  ),
                ),
                Container(
                  width: 1,
                  height: 40.h,
                  color: AppColors.dividerColor.themeColor,
                ),
                Expanded(
                  child: _buildStat(
                    icon: Icons.receipt_long_rounded,
                    label: LocaleKeys.shift_ordersCount.tr(),
                    value: '${summary.paidOrders.length}',
                  ),
                ),
              ],
            ),
          ),
          22.height,
          const ShiftBrandingFooter(),
        ],
      ),
    );
  }

  Widget _buildStat({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, color: AppColors.accentGold.themeColor, size: 20.sp),
        6.height,
        AppText(
          value,
          fontSize: 15,
          fontWeight: FontWeight.w800,
          color: AppColors.textPrimaryColor.themeColor,
        ),
        2.height,
        AppText(
          label,
          fontSize: 11,
          color: AppColors.textSecondaryColor.themeColor,
        ),
      ],
    );
  }
}
