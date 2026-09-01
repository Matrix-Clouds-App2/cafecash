import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_bottom_sheet.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';

class AddEmployeeSheet extends StatefulWidget {
  const AddEmployeeSheet({super.key, required this.onSubmit});

  final void Function(String name, String phone, String email) onSubmit;

  static Future<void> show(
    BuildContext context, {
    required void Function(String name, String phone, String email) onSubmit,
  }) {
    return AppBottomSheet.show(
      context,
      title: LocaleKeys.employees_addEmployee.tr(),
      child: AddEmployeeSheet(onSubmit: onSubmit),
    );
  }

  @override
  State<AddEmployeeSheet> createState() => _AddEmployeeSheetState();
}

class _AddEmployeeSheetState extends State<AddEmployeeSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.pop(context);
    widget.onSubmit(
      _nameCtrl.text.trim(),
      _phoneCtrl.text.trim(),
      _emailCtrl.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomTextField(
            controller: _nameCtrl,
            hint: LocaleKeys.common_name.tr(),
            prefixIcon: const Icon(Icons.person_outline_rounded),
            validator: (value) => (value == null || value.trim().isEmpty)
                ? LocaleKeys.validation_required.tr()
                : null,
          ),
          14.height,
          CustomTextField(
            controller: _phoneCtrl,
            hint: LocaleKeys.common_phone.tr(),
            keyboardType: TextInputType.phone,
            prefixIcon: const Icon(Icons.phone_outlined),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return LocaleKeys.validation_required.tr();
              }
              if (value.trim().length < 8 || value.trim().length > 11) {
                return LocaleKeys.validation_invalidPhone.tr();
              }
              return null;
            },
          ),
          14.height,
          CustomTextField(
            controller: _emailCtrl,
            hint: LocaleKeys.auth_email.tr(),
            keyboardType: TextInputType.emailAddress,
            prefixIcon: const Icon(Icons.email_outlined),
            validator: (value) {
              final trimmed = value?.trim() ?? '';
              if (trimmed.isEmpty) {
                return LocaleKeys.validation_required.tr();
              }
              if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(trimmed)) {
                return LocaleKeys.validation_invalidEmail.tr();
              }
              return null;
            },
          ),
          24.height,
          CustomButton(
            title: LocaleKeys.common_save.tr(),
            onTap: _submit,
          ),
        ],
      ),
    );
  }
}
