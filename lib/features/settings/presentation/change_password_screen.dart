import 'package:easy_localization/easy_localization.dart';
import 'package:app_base/core/extensions/extensions.dart';
import 'package:app_base/core/widgets/app_button.dart';
import 'package:app_base/core/widgets/app_text.dart';
import 'package:app_base/core/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/utils/app_colors.dart';
import '../../../core/utils/locale_keys.dart';
import '../logic/settings_cubit.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _oldPassCtrl = TextEditingController();
  final _newPassCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();

  @override
  void dispose() {
    _oldPassCtrl.dispose();
    _newPassCtrl.dispose();
    _confirmPassCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<SettingsCubit>().changePassword(
          oldPassword: _oldPassCtrl.text.trim(),
          newPassword: _newPassCtrl.text.trim(),
          newPasswordConfirmation: _confirmPassCtrl.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;

    return BlocListener<SettingsCubit, SettingsState>(
      listener: (context, state) {
        if (state is ChangePasswordSuccess) {
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
                LocaleKeys.settings_changePassword.tr(),
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
              AppText(
                LocaleKeys.settings_changePasswordSubtitle.tr(),
                fontSize: 11,
                fontWeight: FontWeight.w400,
                color: Colors.white.withValues(alpha: 0.75),
              ),
            ],
          ),
        ),
        body: BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, state) {
            final isLoading = state is ChangePasswordLoading;

            return SingleChildScrollView(
              padding:
                  EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
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
                        child: Icon(Icons.lock_outline_rounded,
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
                          // Old password
                          _FieldLabel(
                              LocaleKeys.settings_oldPassword.tr()),
                          8.height,
                          CustomTextField(
                            hint: LocaleKeys.settings_oldPassword.tr(),
                            controller: _oldPassCtrl,
                            isPassword: true,
                            prefixIcon: Icon(Icons.lock_outline_rounded,
                                color: primary, size: 20.sp),
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return LocaleKeys.validation_required.tr();
                              }
                              if (v.length < 6) {
                                return LocaleKeys
                                    .validation_shortPassword
                                    .tr();
                              }
                              return null;
                            },
                          ),
                          16.height,

                          // New password
                          _FieldLabel(
                              LocaleKeys.settings_newPassword.tr()),
                          8.height,
                          CustomTextField(
                            hint: LocaleKeys.settings_newPassword.tr(),
                            controller: _newPassCtrl,
                            isPassword: true,
                            prefixIcon: Icon(
                                Icons.lock_reset_outlined,
                                color: primary,
                                size: 20.sp),
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return LocaleKeys.validation_required.tr();
                              }
                              if (v.length < 6) {
                                return LocaleKeys
                                    .validation_shortPassword
                                    .tr();
                              }
                              return null;
                            },
                          ),
                          16.height,

                          // Confirm new password
                          _FieldLabel(LocaleKeys
                              .settings_confirmNewPassword
                              .tr()),
                          8.height,
                          CustomTextField(
                            hint: LocaleKeys.settings_confirmNewPassword
                                .tr(),
                            controller: _confirmPassCtrl,
                            isPassword: true,
                            prefixIcon: Icon(Icons.lock_outline_rounded,
                                color: primary, size: 20.sp),
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return LocaleKeys.validation_required.tr();
                              }
                              if (v != _newPassCtrl.text) {
                                return LocaleKeys
                                    .settings_passwordMismatch
                                    .tr();
                              }
                              return null;
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

