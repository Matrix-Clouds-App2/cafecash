import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/custom_tap_effect.dart';
import '../../../orders/data/models/order_entity.dart';

class TreasuryPaymentMethodSelector extends StatelessWidget {
  const TreasuryPaymentMethodSelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final PaymentMethod value;
  final ValueChanged<PaymentMethod> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _MethodOption(
            icon: Icons.payments_outlined,
            label: LocaleKeys.orders_cash.tr(),
            selected: value == PaymentMethod.cash,
            onTap: () => onChanged(PaymentMethod.cash),
          ),
        ),
        10.width,
        Expanded(
          child: _MethodOption(
            icon: Icons.account_balance_wallet_outlined,
            label: LocaleKeys.orders_wallet.tr(),
            selected: value == PaymentMethod.wallet,
            onTap: () => onChanged(PaymentMethod.wallet),
          ),
        ),
      ],
    );
  }
}

class _MethodOption extends StatelessWidget {
  const _MethodOption({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.textPrimaryColor.themeColor;
    final color = selected ? Colors.white : AppColors.textSecondaryColor.themeColor;

    return CustomTapEffect(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: selected
              ? primary
              : AppColors.cardColor.themeColor,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: selected ? primary : AppColors.dividerColor.themeColor,
            width: 1.w,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 22.sp),
            6.height,
            AppText(
              label,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ],
        ),
      ),
    );
  }
}
