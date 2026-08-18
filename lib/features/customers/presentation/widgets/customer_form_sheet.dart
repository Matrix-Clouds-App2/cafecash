import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_bottom_sheet.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../data/models/customer_entity.dart';

class CustomerFormSheet extends StatefulWidget {
  const CustomerFormSheet({
    super.key,
    this.customer,
    required this.onSubmit,
  });

  final CustomerEntity? customer;
  final void Function(String name, String phone) onSubmit;

  static Future<void> show(
    BuildContext context, {
    CustomerEntity? customer,
    required void Function(String name, String phone) onSubmit,
  }) {
    return AppBottomSheet.show(
      context,
      title: customer == null
          ? LocaleKeys.customers_addCustomer.tr()
          : LocaleKeys.customers_editCustomer.tr(),
      child: CustomerFormSheet(customer: customer, onSubmit: onSubmit),
    );
  }

  @override
  State<CustomerFormSheet> createState() => _CustomerFormSheetState();
}

class _CustomerFormSheetState extends State<CustomerFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _phoneCtrl;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.customer?.name ?? '');
    _phoneCtrl = TextEditingController(text: widget.customer?.phone ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.pop(context);
    widget.onSubmit(_nameCtrl.text.trim(), _phoneCtrl.text.trim());
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
              if (value.trim().length < 8) {
                return LocaleKeys.validation_invalidPhone.tr();
              }
              if (value.trim().length > 11) {
                return LocaleKeys.validation_invalidPhone.tr();
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
