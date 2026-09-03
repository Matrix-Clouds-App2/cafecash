import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_constants.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_text.dart';
import '../../data/models/subscription_plan_model.dart';
import '../subscription_labels.dart';

class SubscriptionPlanCard extends StatelessWidget {
  const SubscriptionPlanCard({
    super.key,
    required this.plan,
    this.isCurrent = false,
  });

  final SubscriptionPlanModel plan;
  final bool isCurrent;

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;
    final gold = AppColors.accentGold.themeColor;

    return Container(
      width: double.infinity,
      padding: 14.paddingAll,
      decoration: BoxDecoration(
        color: AppColors.cardColor.themeColor,
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius.r),
        border: Border.all(
          color: isCurrent ? primary : AppColors.dividerColor.themeColor,
          width: isCurrent ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 42.r,
            height: 42.r,
            decoration: BoxDecoration(
              color: gold.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.local_cafe_rounded, color: gold, size: 20.sp),
          ),
          12.width,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: AppText(
                        SubscriptionLabels.planNameFor(plan),
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        color: AppColors.textPrimaryColor.themeColor,
                      ),
                    ),
                    if (isCurrent) ...[
                      8.width,
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.w, vertical: 2.h),
                        decoration: BoxDecoration(
                          color: primary.withValues(alpha: 0.16),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: AppText(
                          LocaleKeys.subscription_currentPlanLabel.tr(),
                          fontSize: 9.5,
                          fontWeight: FontWeight.w700,
                          color: primary,
                        ),
                      ),
                    ],
                  ],
                ),
                3.height,
                AppText(
                  SubscriptionLabels.duration(plan),
                  fontSize: 11.5,
                  color: AppColors.textSecondaryColor.themeColor,
                ),
              ],
            ),
          ),
          10.width,
          AppText(
            SubscriptionLabels.price(plan.price),
            fontSize: 13.5,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimaryColor.themeColor,
          ),
        ],
      ),
    );
  }
}
