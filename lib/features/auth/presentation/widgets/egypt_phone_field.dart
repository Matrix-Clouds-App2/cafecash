import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/custom_text_field_phone/custom_text_field_phone_code.dart';

class EgyptPhoneField extends StatelessWidget {
  const EgyptPhoneField({
    super.key,
    required this.controller,
    this.onChanged,
  });

  final TextEditingController controller;
  final ValueChanged<PhoneNumber>? onChanged;

  @override
  Widget build(BuildContext context) {
    return CustomTextFieldPhoneCode(
      hint: LocaleKeys.auth_phone.tr(),
      controller: controller,
      egyptIsInitial: true,
      isCountryEditable: false,
      keyboardType: TextInputType.phone,
      invalidNumberMessage: LocaleKeys.validation_invalidPhone.tr(),
      onChanged: onChanged,
    );
  }
}
