import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_overlay.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_bottom_sheet.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/custom_tap_effect.dart';
import '../../data/models/subscription_plan_model.dart';
import '../subscription_labels.dart';

enum PlanPickerMode { activate, renew, change }

class PlanPickerSheet extends StatefulWidget {
  const PlanPickerSheet({
    super.key,
    required this.plans,
    required this.mode,
    required this.onSubmit,
    this.currentPlanCode,
  });

  final List<SubscriptionPlanModel> plans;
  final PlanPickerMode mode;
  final String? currentPlanCode;
  final void Function(String planCode, String? effectiveMode, String? notes)
      onSubmit;

  static Future<void> show(
    BuildContext context, {
    required List<SubscriptionPlanModel> plans,
    required PlanPickerMode mode,
    String? currentPlanCode,
    required void Function(
            String planCode, String? effectiveMode, String? notes)
        onSubmit,
  }) {
    return AppBottomSheet.show(
      context,
      title: _titleFor(mode),
      child: PlanPickerSheet(
        plans: plans,
        mode: mode,
        currentPlanCode: currentPlanCode,
        onSubmit: onSubmit,
      ),
    );
  }

  static String _titleFor(PlanPickerMode mode) {
    switch (mode) {
      case PlanPickerMode.activate:
        return LocaleKeys.subscription_sheetActivateTitle.tr();
      case PlanPickerMode.renew:
        return LocaleKeys.subscription_sheetRenewTitle.tr();
      case PlanPickerMode.change:
        return LocaleKeys.subscription_sheetChangeTitle.tr();
    }
  }

  @override
  State<PlanPickerSheet> createState() => _PlanPickerSheetState();
}

class _PlanPickerSheetState extends State<PlanPickerSheet> {
  final _notesCtrl = TextEditingController();
  String? _selectedCode;
  String _effectiveMode = 'after_current';

  @override
  void initState() {
    super.initState();
    if (widget.mode == PlanPickerMode.renew) {
      _selectedCode = widget.currentPlanCode;
    }
  }

  @override
  void dispose() {
    _notesCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    final code = _selectedCode;
    if (code == null) {
      AppOverlay.showError(LocaleKeys.subscription_selectPlanRequired.tr());
      return;
    }
    Navigator.pop(context);
    widget.onSubmit(
      code,
      widget.mode == PlanPickerMode.change ? _effectiveMode : null,
      _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final plan in widget.plans) ...[
          _SelectableTile(
            title: SubscriptionLabels.planNameFor(plan),
            subtitle: SubscriptionLabels.duration(plan),
            trailing: SubscriptionLabels.price(plan.price),
            selected: _selectedCode == plan.code,
            onTap: () => setState(() => _selectedCode = plan.code),
          ),
          10.height,
        ],
        if (widget.mode == PlanPickerMode.change) ...[
          6.height,
          AppText(
            LocaleKeys.subscription_effectiveModeLabel.tr(),
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimaryColor.themeColor,
          ),
          10.height,
          _SelectableTile(
            title: LocaleKeys.subscription_effectiveAfterCurrent.tr(),
            selected: _effectiveMode == 'after_current',
            onTap: () => setState(() => _effectiveMode = 'after_current'),
          ),
          10.height,
          _SelectableTile(
            title: LocaleKeys.subscription_effectiveImmediately.tr(),
            selected: _effectiveMode == 'immediately',
            onTap: () => setState(() => _effectiveMode = 'immediately'),
          ),
          14.height,
        ] else
          4.height,
        CustomTextField(
          controller: _notesCtrl,
          hint: LocaleKeys.subscription_notesLabel.tr(),
          maxLines: 2,
          prefixIcon: const Icon(Icons.notes_rounded),
        ),
        20.height,
        CustomButton(
          title: LocaleKeys.subscription_actionConfirm.tr(),
          onTap: _submit,
        ),
      ],
    );
  }
}

class _SelectableTile extends StatelessWidget {
  const _SelectableTile({
    required this.title,
    required this.selected,
    required this.onTap,
    this.subtitle,
    this.trailing,
  });

  final String title;
  final String? subtitle;
  final String? trailing;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;
    final borderColor = selected ? primary : AppColors.dividerColor.themeColor;

    return CustomTapEffect(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: selected
              ? primary.withValues(alpha: 0.10)
              : AppColors.surfaceColor.themeColor,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: borderColor, width: selected ? 1.5 : 1),
        ),
        child: Row(
          children: [
            Icon(
              selected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_unchecked_rounded,
              size: 20.sp,
              color:
                  selected ? primary : AppColors.textSecondaryColor.themeColor,
            ),
            10.width,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    title,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimaryColor.themeColor,
                  ),
                  if (subtitle != null && subtitle!.isNotEmpty) ...[
                    2.height,
                    AppText(
                      subtitle!,
                      fontSize: 11,
                      color: AppColors.textSecondaryColor.themeColor,
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null && trailing!.isNotEmpty) ...[
              10.width,
              AppText(
                trailing!,
                fontSize: 12.5,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimaryColor.themeColor,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
