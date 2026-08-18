import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_constants.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/app_text_field.dart';

class ShiftAmountCard extends StatelessWidget {
  const ShiftAmountCard({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
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
            width: 64.w,
            height: 64.w,
            decoration: BoxDecoration(
              color: AppColors.primaryColor.themeColor.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(18.r),
            ),
            child: Icon(
              Icons.point_of_sale_rounded,
              size: 30.sp,
              color: AppColors.textPrimaryColor.themeColor,
            ),
          ),
          18.height,
          AppText(
            LocaleKeys.shift_question.tr(),
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimaryColor.themeColor,
          ),
          20.height,
          CustomTextField(
            hint: LocaleKeys.shift_amountHint.tr(),
            controller: controller,
            keyboardType: TextInputType.number,
          ),
        ],
      ),
    );
  }
}
