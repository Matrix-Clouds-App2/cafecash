import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../extensions/extensions.dart';
import '../utils/app_colors.dart';
import '../utils/locale_keys.dart';
import 'app_bottom_sheet.dart';
import 'app_button.dart';
import 'app_text.dart';
import 'app_text_field.dart';

class CancelReasonSheet {
  CancelReasonSheet._();

  static Future<String?> show(
    BuildContext context, {
    required String title,
    required String message,
    required String confirmLabel,
  }) {
    return AppBottomSheet.show<String>(
      context,
      title: title,
      child: _CancelReasonForm(message: message, confirmLabel: confirmLabel),
    );
  }
}

class _CancelReasonForm extends StatefulWidget {
  const _CancelReasonForm({required this.message, required this.confirmLabel});

  final String message;
  final String confirmLabel;

  @override
  State<_CancelReasonForm> createState() => _CancelReasonFormState();
}

class _CancelReasonFormState extends State<_CancelReasonForm> {
  final _formKey = GlobalKey<FormState>();
  final _reasonCtrl = TextEditingController();

  @override
  void dispose() {
    _reasonCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.pop(context, _reasonCtrl.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final error = AppColors.errorColor.themeColor;

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            widget.message,
            fontSize: 13,
            color: AppColors.textSecondaryColor.themeColor,
          ),
          16.height,
          CustomTextField(
            controller: _reasonCtrl,
            hint: LocaleKeys.common_cancelReasonHint.tr(),
            maxLines: 3,
            validator: (value) => (value == null || value.trim().isEmpty)
                ? LocaleKeys.validation_required.tr()
                : null,
          ),
          20.height,
          CustomButton(
            onTap: _submit,
            title: widget.confirmLabel,
            color: error,
            borderColor: error,
            textColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
