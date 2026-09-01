import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_bottom_sheet.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../data/models/employee_model.dart';

class EditEmployeeSheet extends StatefulWidget {
  const EditEmployeeSheet({
    super.key,
    required this.employee,
    required this.onSubmit,
  });

  final EmployeeModel employee;
  final void Function(String name, String email, String status) onSubmit;

  static Future<void> show(
    BuildContext context, {
    required EmployeeModel employee,
    required void Function(String name, String email, String status)
        onSubmit,
  }) {
    return AppBottomSheet.show(
      context,
      title: LocaleKeys.employees_editEmployee.tr(),
      child: EditEmployeeSheet(employee: employee, onSubmit: onSubmit),
    );
  }

  @override
  State<EditEmployeeSheet> createState() => _EditEmployeeSheetState();
}

class _EditEmployeeSheetState extends State<EditEmployeeSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _emailCtrl;
  late bool _isActive;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.employee.name);
    _emailCtrl = TextEditingController(text: widget.employee.email ?? '');
    _isActive = widget.employee.isActive;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.pop(context);
    widget.onSubmit(
      _nameCtrl.text.trim(),
      _emailCtrl.text.trim(),
      _isActive ? 'active' : 'inactive',
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
