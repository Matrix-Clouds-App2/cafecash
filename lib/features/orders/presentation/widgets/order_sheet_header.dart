import 'package:app_base/core/widgets/custom_tap_effect.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_text.dart';

class OrderSheetHeader extends StatelessWidget {
  const OrderSheetHeader({
    super.key,
    required this.total,
    required this.label,
    required this.number,
  });

  final double total;

  final String label;
  final int number;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomTapEffect(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.close,
                size: 22, color: AppColors.accentGold.themeColor),
          ),
          AppText(
            '$label $number',
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimaryColor.themeColor,
          ),
          AppText(
            '${total.toStringAsFixed(0)} ${LocaleKeys.common_currency.tr()}',
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppColors.successColor.themeColor,
          ),
        ],
      ),
    );
  }
}
