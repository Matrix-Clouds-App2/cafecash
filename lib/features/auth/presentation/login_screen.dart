import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/router/routes.dart';
import '../../../core/extensions/extensions.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_images.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/custom_text_field_phone/custom_text_field_phone_code.dart';
import '../logic/auth_cubit.dart';
import 'widgets/auth_field_label.dart';
import 'widgets/auth_header_section.dart';
import 'widgets/dashed_guest_button.dart';
import 'widgets/egypt_phone_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneCtrl = TextEditingController();
  PhoneNumber? _phoneNumber;
  bool _loading = false;

  @override
  void dispose() {
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final phone = _phoneNumber?.number ?? _phoneCtrl.text.trim();

    setState(() => _loading = true);
    // No password-based login endpoint — requesting an OTP for an existing
    // phone *is* "logging in"; verifying it on the next screen is what
    // actually returns the token.
    final ok = await context.read<AuthCubit>().requestOtp(phone);
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

  void _continueAsGuest() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      Routes.layoutScreen,
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF4F5F3),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AuthHeaderSection(image: AppImages.login),
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
                      LocaleKeys.auth_login.tr(),
                      fontSize: 24,
                      color: const Color(0xFF17212B),
                      fontWeight: FontWeight.w700,
                    ),
                    14.height,
                    AuthFieldLabel(text: LocaleKeys.auth_phone.tr()),
                    8.height,
                    EgyptPhoneField(
                      controller: _phoneCtrl,
                      onChanged: (value) => _phoneNumber = value,
                    ),
                    22.height,
                    CustomButton(
                      title: LocaleKeys.auth_login.tr(),
                      loading: _loading,
                      onTap: _submit,
                    ),
                    18.height,
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: const Color(0xFFD4D9D3),
                            thickness: 1,
                            endIndent: 8.w,
                          ),
                        ),
                        AppText(
                          LocaleKeys.auth_or.tr(),
                          fontSize: 14,
                          color: const Color(0xFF9AA19C),
                          fontWeight: FontWeight.w600,
                        ),
                        Expanded(
                          child: Divider(
                            color: const Color(0xFFD4D9D3),
                            thickness: 1,
                            indent: 8.w,
                          ),
                        ),
                      ],
                    ),
                    18.height,
                    DashedGuestButton(
                      label: LocaleKeys.auth_continueAsGuest.tr(),
                      color: AppColors.textPrimaryColor.themeColor,
                      onTap: _continueAsGuest,
                    ),
                    20.height,
                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AppText(
                            LocaleKeys.auth_dontHaveAccount.tr(),
                            fontSize: 14,
                            color: const Color(0xFF9AA19C),
                            fontWeight: FontWeight.w500,
                          ),
                          4.width,
                          GestureDetector(
                            onTap: () => Navigator.pushNamed(
                                context, Routes.registerScreen),
                            child: AppText(
                              LocaleKeys.auth_register.tr(),
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
