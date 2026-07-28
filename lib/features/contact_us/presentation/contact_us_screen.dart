import 'package:easy_localization/easy_localization.dart';
import 'package:coffee_shop/core/extensions/extensions.dart';
import 'package:coffee_shop/core/utils/app_constants.dart';
import 'package:coffee_shop/core/widgets/app_button.dart';
import 'package:coffee_shop/core/widgets/app_text.dart';
import 'package:coffee_shop/core/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_overlay.dart';
import '../../../core/utils/locale_keys.dart';
import '../logic/contact_us_cubit.dart';
import '../logic/contact_us_state.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl    = TextEditingController();
  final _emailCtrl   = TextEditingController();
  final _phoneCtrl   = TextEditingController();
  final _messageCtrl = TextEditingController();

  bool _canEditName = true;
  bool _canEditEmail = true;
  bool _canEditPhone = true;

  bool _hasValue(String? value) => value?.trim().isNotEmpty ?? false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _messageCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<ContactUsCubit>().send(
          name:    _nameCtrl.text.trim(),
          email:   _emailCtrl.text.trim(),
          phone:   _phoneCtrl.text.trim(),
          message: _messageCtrl.text.trim(),
        );
  }

  @override
  void initState() {
    super.initState();
    _nameCtrl.text = kUserModel?.name ?? '';
    _emailCtrl.text = kUserModel?.email ?? '';
    _phoneCtrl.text = kUserModel?.phone ?? '';

    final isGuestUser = kIsGuest;
    _canEditName = isGuestUser || !_hasValue(_nameCtrl.text);
    _canEditEmail = isGuestUser || !_hasValue(_emailCtrl.text);
    _canEditPhone = isGuestUser || !_hasValue(_phoneCtrl.text);
  }
  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;

    return BlocListener<ContactUsCubit, ContactUsState>(
      listener: (context, state) {
        if (state is ContactUsSuccess) {
          AppOverlay.showSuccess(LocaleKeys.contactUs_successMessage.tr());
          Navigator.pop(context);
        } else if (state is ContactUsError) {
          AppOverlay.showError(state.message);
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
                LocaleKeys.contactUs_title.tr(),
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
              AppText(
                LocaleKeys.contactUs_subtitle.tr(),
                fontSize: 11,
                fontWeight: FontWeight.w400,
                color: Colors.white.withValues(alpha: 0.75),
              ),
            ],
          ),
        ),
        body: BlocBuilder<ContactUsCubit, ContactUsState>(
          builder: (context, state) {
            final isLoading = state is ContactUsLoading;

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Icon header ──────────────────────────────────────────
                    Center(
                      child: Container(
                        width: 80.r,
                        height: 80.r,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: primary.withValues(alpha: 0.1),
                        ),
                        child: Icon(Icons.headset_mic_outlined,
                            color: primary, size: 36.sp),
                      ),
                    ),
                    28.height,

                    // ── Form card ────────────────────────────────────────────
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
                          _FieldLabel(LocaleKeys.contactUs_name.tr()),
                          8.height,
                          CustomTextField(
                            hint: LocaleKeys.contactUs_name.tr(),
                            controller: _nameCtrl,
                            readOnly: !_canEditName,
                            prefixIcon: Icon(Icons.person_outline_rounded,
                                color: primary, size: 20.sp),
                            validator: (v) => (v == null || v.isEmpty)
                                ? LocaleKeys.validation_required.tr()
                                : null,
                          ),
                          16.height,

                          // Email
                          _FieldLabel(LocaleKeys.contactUs_email.tr()),
                          8.height,
                          CustomTextField(
                            hint: LocaleKeys.contactUs_email.tr(),
                            controller: _emailCtrl,
                            readOnly: !_canEditEmail,
                            keyboardType: TextInputType.emailAddress,
                            prefixIcon: Icon(Icons.email_outlined,
                                color: primary, size: 20.sp),
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return LocaleKeys.validation_required.tr();
                              }
                              if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w]{2,}$')
                                  .hasMatch(v)) {
                                return LocaleKeys.validation_invalidEmail.tr();
                              }
                              return null;
                            },
                          ),
                          16.height,

                          // Phone
                          _FieldLabel(LocaleKeys.contactUs_phone.tr()),
                          8.height,
                          CustomTextField(
                            hint: LocaleKeys.contactUs_phone.tr(),
                            controller: _phoneCtrl,
                            readOnly: !_canEditPhone,
                            keyboardType: TextInputType.phone,
                            prefixIcon: Icon(Icons.phone_outlined,
                                color: primary, size: 20.sp),
                            validator: (v) => (v == null || v.isEmpty)
                                ? LocaleKeys.validation_required.tr()
                                : null,
                          ),
                          16.height,

                          // Message
                          _FieldLabel(LocaleKeys.contactUs_message.tr()),
                          8.height,
                          CustomTextField(
                            hint: LocaleKeys.contactUs_message.tr(),
                            controller: _messageCtrl,
                            maxLines: 5,
                            // prefixIcon: Icon(Icons.message_outlined,
                            //     color: primary, size: 20.sp),
                            validator: (v) => (v == null || v.isEmpty)
                                ? LocaleKeys.validation_required.tr()
                                : null,
                          ),
                        ],
                      ),
                    ),
                    32.height,

                    // ── Submit button ────────────────────────────────────────
                    CustomButton(
                      onTap: isLoading ? () {} : _submit,
                      title: LocaleKeys.contactUs_send.tr(),
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
