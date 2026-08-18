// `intl` (re-exported by easy_localization) declares its own `TextDirection`
// class that would otherwise shadow `dart:ui`'s (used below via
// `Directionality.of`) — hidden here to keep `TextDirection.rtl` unambiguous.
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_constants.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/custom_tap_effect.dart';

/// Total row + "back" shortcut, above the payment action buttons.
class OrderSummaryBar extends StatelessWidget {
  const OrderSummaryBar({super.key, required this.total, required this.onBack});

  final double total;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 0, 16.w, 12.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: AppColors.cardColor.themeColor,
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppText(
            '${LocaleKeys.orders_total.tr()}: ${total.toStringAsFixed(0)} '
            '${LocaleKeys.common_currency.tr()}',
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: AppColors.successColor.themeColor,
          ),
          CustomTapEffect(
            onTap: onBack,
            child: Row(
              children: [
                AppText(
                  LocaleKeys.orders_back.tr(),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondaryColor.themeColor,
                ),
                4.width,
                Icon(
                  Directionality.of(context) == TextDirection.rtl
                      ? Icons.arrow_forward_rounded
                      : Icons.arrow_back_rounded,
                  size: 16.sp,
                  color: AppColors.textSecondaryColor.themeColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
