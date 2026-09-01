import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/router/routes.dart';
import '../../../core/extensions/extensions.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_images.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/custom_text_field_phone/custom_text_field_phone_code.dart';
import '../logic/auth_cubit.dart';
import 'widgets/auth_field_label.dart';
import 'widgets/auth_header_section.dart';
import 'widgets/egypt_phone_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _cafeNameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  PhoneNumber? _phoneNumber;
  bool _loading = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _cafeNameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final name = _nameCtrl.text.trim();
    final cafeName = _cafeNameCtrl.text.trim();
    final email = _emailCtrl.text.trim();
    final phone = _phoneNumber?.number ?? _phoneCtrl.text.trim();

    setState(() => _loading = true);
    final ok = await context.read<AuthCubit>().register(
          name: name,
          cafeName: cafeName,
          phone: phone,
          email: email,
        );
    if (!mounted) return;
    setState(() => _loading = false);

    if (ok) {
      Navigator.pushNamed(
        context,
        Routes.otpScreen,
        arguments: {'phone': phone},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF4F5F3),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AuthHeaderSection(image: AppImages.register),
              Container(
                padding: 16.paddingHorizontal,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFF4F5F3),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    16.height,
                    AppText(
                      LocaleKeys.auth_register.tr(),
                      fontSize: 24,
                      color: const Color(0xFF17212B),
                      fontWeight: FontWeight.w700,
                    ),
                    6.height,
                    AppText(
                      LocaleKeys.auth_registerSubtitle.tr(),
                      fontSize: 13,
                      color: const Color(0xFF9AA19C),
                      fontWeight: FontWeight.w500,
                    ),
                    20.height,
                    AuthFieldLabel(text: LocaleKeys.auth_name.tr()),
                    8.height,
                    CustomTextField(
                      hint: LocaleKeys.auth_name.tr(),
                      controller: _nameCtrl,
                      keyboardType: TextInputType.name,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return LocaleKeys.validation_required.tr();
                        }
                        return null;
                      },
                    ),
                    14.height,
                    AuthFieldLabel(text: LocaleKeys.auth_cafeName.tr()),
                    8.height,
                    CustomTextField(
                      hint: LocaleKeys.auth_cafeName.tr(),
                      controller: _cafeNameCtrl,
                      keyboardType: TextInputType.text,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return LocaleKeys.validation_required.tr();
                        }
                        return null;
                      },
                    ),
                    14.height,
                    // AuthFieldLabel(text: LocaleKeys.auth_email.tr()),
                    // 8.height,
                    // CustomTextField(
                    //   hint: LocaleKeys.auth_email.tr(),
                    //   controller: _emailCtrl,
                    //   keyboardType: TextInputType.emailAddress,
                    //   validator: (v) {
                    //     final value = v?.trim() ?? '';
                    //     if (value.isEmpty) {
                    //       return LocaleKeys.validation_required.tr();
                    //     }
                    //     if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                    //         .hasMatch(value)) {
                    //       return LocaleKeys.validation_invalidEmail.tr();
                    //     }
                    //     return null;
                    //   },
                    // ),
                    // 14.height,
                    AuthFieldLabel(text: LocaleKeys.auth_phone.tr()),
                    8.height,
                    EgyptPhoneField(
                      controller: _phoneCtrl,
                      onChanged: (value) => _phoneNumber = value,
                    ),
                    24.height,
                    CustomButton(
                      title: LocaleKeys.auth_register.tr(),
                      loading: _loading,
                      onTap: _submit,
                    ),
                    20.height,
                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AppText(
                            LocaleKeys.auth_alreadyHaveAccount.tr(),
                            fontSize: 14,
                            color: const Color(0xFF9AA19C),
                            fontWeight: FontWeight.w500,
                          ),
                          4.width,
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: AppText(
                              LocaleKeys.auth_signIn.tr(),
                              fontSize: 14,
                              color: AppColors.accentGold.themeColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    50.height,
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
