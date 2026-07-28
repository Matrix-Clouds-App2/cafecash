import 'dart:math' as math;

import 'package:easy_localization/easy_localization.dart';
import 'package:app_base/core/extensions/extensions.dart';
import 'package:app_base/core/utils/app_images.dart';
import 'package:app_base/core/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/router/routes.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/primary_header.dart';
import '../logic/auth_cubit.dart';
import '../../profile/logic/profile_cubit.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthCubit>().login(
          email: _emailCtrl.text.trim(),
          password: _passwordCtrl.text,
        );
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
              physics: const ClampingScrollPhysics(),
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
                          LocaleKeys.auth_login.tr(),
                          fontSize: 24,
                          color: const Color(0xFF17212B),
                          fontWeight: FontWeight.w700,
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
                        12.height,
                        16.height,
                        // Center(
                        //   child: TextButton(
                        //     onPressed: () {},
                        //     child: AppText(
                        //       LocaleKeys.auth_forgotPassword.tr(),
                        //       fontSize: 14,
                        //       color: AppColors.accentGold.themeColor,
                        //       fontWeight: FontWeight.w700,
                        //     ),
                        //   ),
                        // ),
                        6.height,
                        CustomButton(
                          title: LocaleKeys.auth_login.tr(),
                          onTap: _submit,
                          loading: isLoading,
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
                        _DashedGuestButton(
                          label: LocaleKeys.auth_continueAsGuest.tr(),
                          color: AppColors.primaryColor.themeColor,
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
        child: Center(
          child: Image.asset(
            AppImages.logo4,
            width: 220.w,
            fit: BoxFit.contain,
          ),
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

class _DashedGuestButton extends StatelessWidget {
  const _DashedGuestButton({
    required this.label,
    required this.color,
    required this.onTap,
  });

  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: CustomPaint(
          painter: _DashedRRectPainter(
            color: color.withValues(alpha: 0.75),
            strokeWidth: 1.3,
            dashLength: 6,
            gapLength: 4,
            radius: 16,
          ),
          child: SizedBox(
            height: 44.h,
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppText(
                    label,
                    fontSize: 16,
                    color: color,
                    fontWeight: FontWeight.w700,
                  ),
                  8.width,
                  Icon(Icons.person_outline, size: 19.sp, color: color),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DashedRRectPainter extends CustomPainter {
  const _DashedRRectPainter({
    required this.color,
    required this.strokeWidth,
    required this.dashLength,
    required this.gapLength,
    required this.radius,
  });

  final Color color;
  final double strokeWidth;
  final double dashLength;
  final double gapLength;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final rect = Offset.zero & size;
    final rRect = RRect.fromRectAndRadius(rect.deflate(strokeWidth / 2), Radius.circular(radius));
    final path = Path()..addRRect(rRect);

    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final end = math.min(distance + dashLength, metric.length);
        canvas.drawPath(metric.extractPath(distance, end), paint);
        distance += dashLength + gapLength;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedRRectPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.dashLength != dashLength ||
        oldDelegate.gapLength != gapLength ||
        oldDelegate.radius != radius;
  }
}
