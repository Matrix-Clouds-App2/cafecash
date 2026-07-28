import 'package:easy_localization/easy_localization.dart';
import 'package:app_base/core/extensions/extensions.dart';
import 'package:app_base/core/utils/app_colors.dart';
import 'package:app_base/core/utils/app_images.dart';
import 'package:app_base/core/widgets/app_text.dart';
import 'package:app_base/core/widgets/custom_tap_effect.dart';
import 'package:app_base/core/widgets/primary_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/utils/convert_helper.dart';
import '../../../../core/utils/locale_keys.dart';

/// The dark-green header shown at the top of the Home screen.
///
/// Reuses [PrimaryHeader] (the same shared base used by the Login screen)
/// for the green background and decorative gold circle, and fills it with
/// home-specific content:
///   • Greeting + chat-icon raw
///   • User name
///   • Event info card (WUF 13 – Azerbaijan 2026 · dates)
class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    this.userName = 'محمد العمري',
    this.onChatTap,
    this.eventTitle,
    this.eventStartDates,
    this.eventEndDates,
    this.eventLocation,
  });

  final String userName;
  final VoidCallback? onChatTap;
  final String? eventTitle;
  final String? eventStartDates;
  final String? eventEndDates;
  final String? eventLocation;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 0.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Greeting row ────────────────────────────────────────────


          // ── User name ────────────────────────────────────────────────


          // const Spacer(),

          // // ── Event info card ──────────────────────────────────────────
          // _EventInfoCard(
          //   title: eventTitle,
          //   endDates: eventEndDates,
          //   startDates: eventStartDates,
          //   location: eventLocation,
          // ),

          // 8.height,
        ],
      ),
    );
  }
}

// ── Private sub-widgets ───────────────────────────────────────────────────────

class ChatIconButton extends StatelessWidget {
  const ChatIconButton({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return CustomTapEffect(
      onTap: onTap,
      child: Container(
        padding: 5.paddingAll+0.paddingTop,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.15),
          ),
        ),
        child: Icon(
          Icons.slow_motion_video,
          color: Colors.white,
        )
      ),
    );
  }
}

class EventInfoCard extends StatelessWidget {
  const EventInfoCard({super.key, this.title, this.startDates,this.endDates, this.location});

  final String? title;
  final String? startDates;
  final String? endDates;
  final String? location;

  @override
  Widget build(BuildContext context) {
    final displayTitle = title?.isNotEmpty == true
        ? title!
        : 'WUF 13 – Azerbaijan 2026';


    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.yellow.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: Colors.yellow.withValues(alpha: 0.18),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            displayTitle,
            fontSize: 15.sp,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
          4.height,
          AppText(
            location??'',
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: Colors.white.withValues(alpha: 0.75),
          ),
          6.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                ConvertHelper.formatDateTime(startDates??''),
                // startDates??'',
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white.withValues(alpha: 0.75),
              ),
              AppText(
                ConvertHelper.formatDateTime(endDates??''),
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white.withValues(alpha: 0.75),
              ),
            ],
          )
        ],
      ),
    );
  }
}

