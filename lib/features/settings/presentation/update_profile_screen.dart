import 'package:easy_localization/easy_localization.dart';
import 'package:app_base/core/extensions/extensions.dart';
import 'package:app_base/core/widgets/app_button.dart';
import 'package:app_base/core/widgets/app_text.dart';
import 'package:app_base/core/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_constants.dart';
import '../../../core/utils/custom_text_field_phone/custom_text_field_phone_code.dart';
import '../../../core/utils/locale_keys.dart';
import '../../profile/logic/profile_cubit.dart';
import '../logic/settings_cubit.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  String _countryCode = '+966';

  @override
  void initState() {
    super.initState();
    final user = kUserModel;
    if (user != null) {
      _nameCtrl.text = user.name;
      _emailCtrl.text = user.email;
      _phoneCtrl.text = user.phone ?? '';
      _countryCode = (user.countryCode?.isNotEmpty ?? false)
          ? user.countryCode!
          : '+966';
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<SettingsCubit>().updateProfile(
          name: _nameCtrl.text.trim(),
          email: _emailCtrl.text.trim(),
          phone: _phoneCtrl.text.trim(),
          countryCode: _countryCode,
        );
  }

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;

    return BlocListener<SettingsCubit, SettingsState>(
      listener: (context, state) {
        if (state is UpdateProfileSuccess) {
          context.read<ProfileCubit>().getProfile();
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F5F3),
        appBar: AppBar(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: Column(
            children: [
              AppText(
                LocaleKeys.settings_updateProfile.tr(),
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
              AppText(
                LocaleKeys.settings_updateProfileSubtitle.tr(),
                fontSize: 11,
                fontWeight: FontWeight.w400,
                color: Colors.white.withValues(alpha: 0.75),
              ),
            ],
          ),
        ),
        body: BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, state) {
            final isLoading = state is UpdateProfileLoading;

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Icon header ────────────────────────────────────────
                    Center(
                      child: Container(
                        width: 80.r,
                        height: 80.r,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: primary.withValues(alpha: 0.1),
                        ),
                        child: Icon(Icons.person_outline_rounded,
                            color: primary, size: 36.sp),
                      ),
                    ),
                    28.height,

                    // ── Form card ──────────────────────────────────────────
                    Container(
                      padding: EdgeInsets.all(20.r),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Name
                          _FieldLabel(LocaleKeys.settings_labelName.tr()),
                          8.height,
                          CustomTextField(
                            hint: LocaleKeys.settings_labelName.tr(),
                            controller: _nameCtrl,
                            keyboardType: TextInputType.name,
                            prefixIcon: Icon(Icons.person_outline_rounded,
                                color: primary, size: 20.sp),
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return LocaleKeys.validation_required.tr();
                              }
                              return null;
                            },
                          ),
                          16.height,

                          // Email
                          _FieldLabel(LocaleKeys.settings_labelEmail.tr()),
                          8.height,
                          CustomTextField(
                            hint: LocaleKeys.settings_labelEmail.tr(),
                            controller: _emailCtrl,
                            keyboardType: TextInputType.emailAddress,
                            prefixIcon: Icon(Icons.email_outlined,
                                color: primary, size: 20.sp),
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
                          16.height,

                          // Phone
                          _FieldLabel(LocaleKeys.settings_labelPhone.tr()),
                          8.height,
                          CustomTextFieldPhoneCode(
                            key: ValueKey('update-profile-phone-$_countryCode'),
                            hint: LocaleKeys.settings_labelPhone.tr(),
                            controller: _phoneCtrl,
                            initialCountryCode: _countryCode,
                            keyboardType: TextInputType.phone,
                            invalidNumberMessage:
                                LocaleKeys.validation_invalidPhone.tr(),
                            onChanged: (phoneNumber) {
                              _countryCode = phoneNumber.countryCode;
                            },
                          ),
                        ],
                      ),
                    ),
                    32.height,

                    // ── Submit button ──────────────────────────────────────
                    CustomButton(
                      onTap: isLoading ? () {} : _submit,
                      title: LocaleKeys.settings_saveChanges.tr(),
                      loading: isLoading,
                    ),
                    16.height,
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: AppText(
        label,
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.textSecondaryColor.themeColor,
      ),
    );
  }
}
