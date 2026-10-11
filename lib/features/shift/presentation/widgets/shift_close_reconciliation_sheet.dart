import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_overlay.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_bottom_sheet.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../data/models/shift_reconciliation.dart';
import '../../data/models/shift_summary.dart';

class ShiftCloseReconciliationSheet extends StatefulWidget {
  const ShiftCloseReconciliationSheet({super.key, required this.summary});

  final ShiftSummary summary;

  static Future<ShiftReconciliation?> show(
    BuildContext context, {
    required ShiftSummary summary,
  }) {
    return AppBottomSheet.show<ShiftReconciliation>(
      context,
      title: LocaleKeys.shift_reconcile_title.tr(),
      child: ShiftCloseReconciliationSheet(summary: summary),
    );
  }

  @override
  State<ShiftCloseReconciliationSheet> createState() =>
      _ShiftCloseReconciliationSheetState();
}

class _ShiftCloseReconciliationSheetState
    extends State<ShiftCloseReconciliationSheet> {
  final _cashController = TextEditingController();
  final _walletController = TextEditingController();

  @override
  void dispose() {
    _cashController.dispose();
    _walletController.dispose();
    super.dispose();
  }

  void _confirm() {
    final cash = double.tryParse(_cashController.text.trim());
    final wallet = double.tryParse(_walletController.text.trim());

    if (cash == null || cash < 0 || wallet == null || wallet < 0) {
      AppOverlay.showError(LocaleKeys.shift_amountInvalid.tr());
      return;
    }

    Navigator.pop(
      context,
      ShiftReconciliation.compute(
        summary: widget.summary,
        actualCash: cash,
        actualWallet: wallet,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        AppText(
          LocaleKeys.shift_reconcile_message.tr(),
          fontSize: 13,
          height: 1.5,
          color: AppColors.textSecondaryColor.themeColor,
        ),
        18.height,
        AppText(
          LocaleKeys.shift_reconcile_cashLabel.tr(),
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimaryColor.themeColor,
        ),
        8.height,
        CustomTextField(
          hint: LocaleKeys.shift_amountHint.tr(),
          controller: _cashController,
          keyboardType: TextInputType.number,
        ),
        16.height,
        AppText(
          LocaleKeys.shift_reconcile_walletLabel.tr(),
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimaryColor.themeColor,
        ),
        8.height,
        CustomTextField(
          hint: LocaleKeys.shift_amountHint.tr(),
          controller: _walletController,
          keyboardType: TextInputType.number,
        ),
        22.height,
        CustomButton(
          onTap: _confirm,
          title: LocaleKeys.shift_closeButton.tr(),
          color: AppColors.errorColor.themeColor,
          borderColor: AppColors.errorColor.themeColor,
          textColor: Colors.white,
        ),
      ],
    );
  }
}
