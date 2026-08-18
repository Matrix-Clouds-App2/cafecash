import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_constants.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_text.dart';

class TreasuryEntryInfoCard extends StatelessWidget {
  const TreasuryEntryInfoCard({super.key, required this.isIncome});

  final bool isIncome;

  @override
  Widget build(BuildContext context) {
    final color = isIncome
        ? AppColors.successColor.themeColor
        : AppColors.errorColor.themeColor;

    return Container(
      width: double.infinity,
      padding: 24.paddingAll,
      decoration: BoxDecoration(
        color: AppColors.cardColor.themeColor,
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 56.w,
            height: 56.w,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: Icon(
              isIncome ? Icons.add_rounded : Icons.remove_rounded,
              color: Colors.white,
              size: 30.sp,
            ),
          ),
          16.height,
          AppText(
            isIncome
                ? LocaleKeys.treasury_receiveInfoTitle.tr()
                : LocaleKeys.treasury_withdrawInfoTitle.tr(),
            fontSize: 15,
            fontWeight: FontWeight.w700,
            textAlign: TextAlign.center,
            color: AppColors.textPrimaryColor.themeColor,
          ),
          8.height,
          AppText(
            isIncome
                ? LocaleKeys.treasury_receiveInfoExample.tr()
                : LocaleKeys.treasury_withdrawInfoExample.tr(),
            fontSize: 13,
            textAlign: TextAlign.center,
            color: AppColors.textSecondaryColor.themeColor,
          ),
        ],
      ),
    );
  }
}
