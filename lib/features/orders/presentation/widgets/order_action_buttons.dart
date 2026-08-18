import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/custom_tap_effect.dart';


class OrderActionButtons extends StatelessWidget {
  const OrderActionButtons({
    super.key,
    required this.onPartialPay,
    required this.onPayFull,
    required this.onCancel,
    required this.onDefer,
  });

  final VoidCallback onPartialPay;
  final VoidCallback onPayFull;
  final VoidCallback onCancel;
  final VoidCallback onDefer;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _ActionButton(
                  label: LocaleKeys.orders_partialPay.tr(),
                  icon: Icons.payments_outlined,
                  color: AppColors.warningColor.themeColor,
                  onTap: onPartialPay,
                ),
              ),
              10.width,
              Expanded(
                child: _ActionButton(
                  label: LocaleKeys.orders_payFull.tr(),
                  icon: Icons.check_circle_outline_rounded,
                  color: AppColors.successColor.themeColor,
                  onTap: onPayFull,
                ),
              ),
            ],
          ),
          10.height,
          Row(
            children: [
              Expanded(
                child: _ActionButton(
                  label: LocaleKeys.orders_cancelOrder.tr(),
                  icon: Icons.delete_outline_rounded,
                  color: AppColors.errorColor.themeColor,
                  onTap: onCancel,
                ),
              ),
              10.width,
              Expanded(
                child: _ActionButton(
                  label: LocaleKeys.orders_defer.tr(),
                  icon: Icons.person_outline_rounded,
                  color: AppColors.infoColor.themeColor,
                  onTap: onDefer,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return CustomTapEffect(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14.h),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(30.r),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.35),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppText(
              label,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
            8.width,
            Icon(icon, color: Colors.white, size: 18.sp),
          ],
        ),
      ),
    );
  }
}
