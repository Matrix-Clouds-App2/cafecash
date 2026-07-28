import 'package:easy_localization/easy_localization.dart';
import 'package:coffee_shop/core/extensions/extensions.dart';
import 'package:coffee_shop/core/utils/locale_keys.dart';
import 'package:coffee_shop/features/home/presentation/widgets/home_countdown_unit.dart';
import 'package:coffee_shop/features/home/presentation/widgets/home_section_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// White card section that displays:
///   • Section title + clock icon
///   • Official launch date subtitle
///   • Row of four [HomeCountdownUnit] tiles (days / hours / minutes / seconds)
class HomeCountdownSection extends StatelessWidget {
  const HomeCountdownSection({
    super.key,
    required this.days,
    required this.hours,
    required this.minutes,
    required this.seconds,
    required this.startDates,
  });

  final int days;
  final int hours;
  final int minutes;
  final int seconds;
  final String? startDates;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      // padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [

          HomeSectionTitle(
            title: LocaleKeys.home_launchTitle.tr(),
            icon: Icons.access_time_rounded,
            subtitle: '${LocaleKeys.home_launchSubtitle.tr()}$startDates',
          ),
          14.verticalSpace,
          Container(
            padding: 16.paddingHorizontal,
            child: Row(
              children: [
                HomeCountdownUnit(
                  value: days,
                  label: LocaleKeys.home_days.tr(),
                ),
                8.horizontalSpace,
                HomeCountdownUnit(
                  value: hours,
                  label: LocaleKeys.home_hours.tr(),
                ),
                8.horizontalSpace,
                HomeCountdownUnit(
                  value: minutes,
                  label: LocaleKeys.home_minutes.tr(),
                ),
                8.horizontalSpace,
                HomeCountdownUnit(
                  value: seconds,
                  label: LocaleKeys.home_seconds.tr(),
                ),
              ],
            ),
          ),
          16.verticalSpace,

        ],
      ),
    );
  }
}

