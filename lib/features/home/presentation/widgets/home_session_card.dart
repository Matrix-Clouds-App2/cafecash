import 'package:app_base/core/extensions/extensions.dart';
import 'package:app_base/core/utils/app_colors.dart';
import 'package:app_base/core/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/widgets/expandable_html.dart';
import '../../data/models/home_model.dart';

class HomeSessionCard extends StatelessWidget {
  const HomeSessionCard({
    super.key,
    required this.forum,
    required this.stripeColor,
  });

  final HomeForumModel forum;
  final Color stripeColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: stripeColor,
            blurRadius: 0,
            offset: const Offset(5, 0),
          ),
        ],
      ),
      padding: 16.paddingAll,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Category badge ───────────────────────────────────────────
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: stripeColor.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(999.r),
            ),
            child: AppText(
              forum.category.name,
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
              color: stripeColor,
            ),
          ),
          4.verticalSpace,

          // ── Title ────────────────────────────────────────────────────
          AppText(
            forum.title,
            fontSize: 16.sp,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF17212B),
            textAlign: TextAlign.right,
          ),
          4.verticalSpace,

          // ── Hall (location) ──────────────────────────────────────────
          AppText(
            forum.hall.name,
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: stripeColor,
          ),
          3.verticalSpace,

          // ── Time + description ───────────────────────────────────────
          Row(
            children: [
              Expanded(child: ExpandableHtml(data: forum.description,)),

              // Expanded(
              //   child:
              //
              //   Html(
              //     data: forum.description,
              //     style: {
              //       'html': Style(
              //         margin: Margins.zero,
              //         padding: HtmlPaddings.zero,
              //       ),
              //       'body': Style(
              //         margin: Margins.zero,
              //         padding: HtmlPaddings.zero,
              //         fontSize: FontSize(12.sp),
              //         fontWeight: FontWeight.w500,
              //         color: AppColors.textSecondaryColor.themeColor,
              //         lineHeight: const LineHeight(1.5),
              //         fontFamily: 'Cairo',
              //       ),
              //       'p': Style(
              //         margin: Margins.zero,
              //         padding: HtmlPaddings.zero,
              //       ),
              //     },
              //   ),
              // ),
              12.horizontalSpace,
              AppText(
                forum.formattedTime,
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: stripeColor,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
