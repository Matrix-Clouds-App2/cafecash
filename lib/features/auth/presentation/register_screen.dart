import 'package:easy_localization/easy_localization.dart';
import 'package:coffee_shop/core/extensions/extensions.dart';
import 'package:coffee_shop/core/utils/app_images.dart';
import 'package:coffee_shop/core/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/router/routes.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/custom_text_field_phone/custom_text_field_phone_code.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/primary_header.dart';
import '../../../main.dart';
import '../logic/auth_cubit.dart';
import '../../profile/logic/profile_cubit.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthCubit>().register(
          name: _nameCtrl.text.trim(),
          email: _emailCtrl.text.trim(),
          phone: _phoneCtrl.text.trim(),
          password: _passwordCtrl.text,
          countryCode: countryCode??''

        );
  }

  String? countryCode='+966';
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          context.read<ProfileCubit>().getProfile();
          Navigator.pushNamedAndRemoveUntil(
              context, Routes.layoutScreen, (_) => false);
        }
      },
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return Scaffold(
            body: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _HeaderSection(),
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
                          _FieldLabel(text: LocaleKeys.auth_name.tr()),
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
                          _FieldLabel(text: LocaleKeys.auth_email.tr()),
                          8.height,
                          CustomTextField(
                            hint: LocaleKeys.auth_email.tr(),
                            controller: _emailCtrl,
                            keyboardType: TextInputType.emailAddress,
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return LocaleKeys.validation_required.tr();
                              }
                              if (!v.contains('@')) {
                                return LocaleKeys.validation_invalidEmail.tr();
                              }
                              return null;
                            },
                          ),
                          if(isAfterTwoDaysResult)
                           ...[ 14.height,
                            _FieldLabel(text: LocaleKeys.auth_phone.tr()),
                          8.height,
                          CustomTextFieldPhoneCode(
                            hint: LocaleKeys.auth_phone.tr(),
                            controller: _phoneCtrl,
                            initialCountryCode: 'SA',
                            egyptIsInitial: false,
                            isRequired: false,
                            keyboardType: TextInputType.phone,
                            invalidNumberMessage: LocaleKeys.validation_invalidPhone.tr(),
                            onCountryChanged: (country){
                              print('asdasdadasasd');
                              print(country.name);
                              print(country.dialCode);
                              if(country.dialCode=='20'){
                                countryCode='+2';
                              }else {
                                countryCode='+${country.dialCode}';
                              }
                              print(country.code);

                            },
                          ),],
                          14.height,
                          _FieldLabel(text: LocaleKeys.auth_password.tr()),
                          8.height,
                          CustomTextField(
                            hint: LocaleKeys.auth_password.tr(),
                            controller: _passwordCtrl,
                            isPassword: true,
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return LocaleKeys.validation_required.tr();
                              }
                              if (v.length < 6) {
                                return LocaleKeys.validation_shortPassword.tr();
                              }
                              return null;
                            },
                          ),
                          24.height,
                          CustomButton(
                            title: LocaleKeys.auth_register.tr(),
                            onTap: _submit,
                            loading: isLoading,
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
        },
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  const _HeaderSection();

  @override
  Widget build(BuildContext context) {
    return PrimaryHeader(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 50.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: Image.asset(
                  AppImages.logo4,
                  width: 220.w,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: AppText(
                'المنصة الرسمية للوفد السعودي المشارك في المنتدى الحضري WUF 13',
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                height: 1.6,
                textAlign: TextAlign.center,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: AppText(
        text,
        fontSize: 14,
        color: AppColors.primaryColor.themeColor,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
