import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/di/injection.dart';
import '../../../core/extensions/extensions.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_overlay.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/app_text_field.dart';
import '../logic/treasury_cubit.dart';
import 'widgets/treasury_entry_info_card.dart';

class TreasuryEntryScreen extends StatefulWidget {
  const TreasuryEntryScreen({super.key, required this.isIncome});

  final bool isIncome;

  @override
  State<TreasuryEntryScreen> createState() => _TreasuryEntryScreenState();
}

class _TreasuryEntryScreenState extends State<TreasuryEntryScreen> {
  final _amountCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  @override
  void dispose() {
    _amountCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  void _save(BuildContext context) {
    final amount = double.tryParse(_amountCtrl.text.trim());
    if (amount == null || amount <= 0) {
      AppOverlay.showError(LocaleKeys.treasury_amountInvalid.tr());
      return;
    }

    getIt<TreasuryCubit>().addTransaction(
      isIncome: widget.isIncome,
      amount: amount,
      notes: _notesCtrl.text,
    );
    AppOverlay.showSuccess(LocaleKeys.treasury_receiptSaved.tr());
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.isIncome
        ? AppColors.successColor.themeColor
        : AppColors.errorColor.themeColor;

    return Scaffold(
      backgroundColor: AppColors.surfaceColor.themeColor,
      appBar: AppBar(
        title: Text(widget.isIncome
            ? LocaleKeys.treasury_receiveCash.tr()
            : LocaleKeys.treasury_withdrawCash.tr()),
        backgroundColor: AppColors.primaryColor.themeColor,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: 16.paddingAll,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TreasuryEntryInfoCard(isIncome: widget.isIncome),
                    20.height,
                    CustomTextField(
                      controller: _amountCtrl,
                      hint: LocaleKeys.treasury_amountLabel.tr(),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      prefixIcon: Icon(Icons.payments_outlined,
                          color: AppColors.textSecondaryColor.themeColor,
                          size: 20.sp),
                    ),
                    14.height,
                    CustomTextField(
                      controller: _notesCtrl,
                      hint: LocaleKeys.treasury_notesLabel.tr(),
                      maxLines: 3,
                      prefixIcon: Icon(Icons.notes_rounded,
                          color: AppColors.textSecondaryColor.themeColor,
                          size: 20.sp),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16.w, 0, 16.w, 20.h),
              child: CustomButton(
                onTap: () => _save(context),
                color: color,
                customRadius: 28,
                height: 56,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppText(
                      LocaleKeys.treasury_saveReceipt.tr(),
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                    8.width,
                    Icon(Icons.save_outlined, color: Colors.white, size: 20.sp),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
