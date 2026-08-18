import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../features/orders/data/models/order_entity.dart';
import '../extensions/extensions.dart';
import '../utils/app_colors.dart';
import '../utils/locale_keys.dart';
import 'app_bottom_sheet.dart';
import 'custom_tap_effect.dart';
import 'sheet_option_tile.dart';

/// Asked right when "دفع بالكامل" is tapped — picking a method here *is*
/// the confirmation (no separate confirm dialog after it).
class PaymentMethodSheet {
  PaymentMethodSheet._();

  static Future<PaymentMethod?> show(BuildContext context) {
    return AppBottomSheet.show<PaymentMethod>(
      context,
      title: LocaleKeys.orders_paymentMethodTitle.tr(),
      child: const _PaymentMethodOptions(),
    );
  }
}

class _PaymentMethodOptions extends StatelessWidget {
  const _PaymentMethodOptions();

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomTapEffect(
          onTap: () => Navigator.pop(context, PaymentMethod.cash),
          child: SheetOptionTile(
            icon: Icons.payments_outlined,
            label: LocaleKeys.orders_cash.tr(),
            color: primary,
          ),
        ),
        10.height,
        CustomTapEffect(
          onTap: () => Navigator.pop(context, PaymentMethod.wallet),
          child: SheetOptionTile(
            icon: Icons.account_balance_wallet_outlined,
            label: LocaleKeys.orders_wallet.tr(),
            color: primary,
          ),
        ),
      ],
    );
  }
}
