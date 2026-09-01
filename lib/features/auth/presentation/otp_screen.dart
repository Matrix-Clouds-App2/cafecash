import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/router/routes.dart';
import '../../../core/extensions/extensions.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_overlay.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text.dart';
import '../../profile/logic/profile_cubit.dart';
import '../../sync/presentation/login_sync_flow.dart';
import '../logic/auth_cubit.dart';
import 'widgets/otp_code_row.dart';
import 'widgets/otp_header.dart';
import 'widgets/otp_resend_timer.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key, required this.phone});

  final String phone;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String _code = '';
  bool _loading = false;

  Future<void> _verify() async {
    if (_code.length != 4) {
      AppOverlay.showError(LocaleKeys.otp_invalidCode.tr());
      return;
    }

    setState(() => _loading = true);
    final ok = await context
        .read<AuthCubit>()
        .verifyOtp(phone: widget.phone, otp: _code);
    if (!mounted) return;
    if (!ok) {
      setState(() => _loading = false);
      return;
    }

    // Populates `kUserModel`/`ProfileCubit` right away (same call `app.dart`
    // makes on a cold start for an already-logged-in session) so the
    // drawer/account screen show real data immediately.
    await context.read<ProfileCubit>().getProfile();
    if (!mounted) return;

    final synced = await runMandatoryLoginSync(context);
    if (!mounted) return;
    if (!synced) {
      context.read<ProfileCubit>().reset();
      context.read<AuthCubit>().logout();
      Navigator.pushNamedAndRemoveUntil(
        context,
        Routes.loginScreen,
        (_) => false,
      );
      return;
    }

    Navigator.pushNamedAndRemoveUntil(
      context,
      Routes.layoutScreen,
      (_) => false,
    );
  }

  void _resend() => context.read<AuthCubit>().requestOtp(widget.phone);

  void _onCodeChanged(String code) {
    setState(() => _code = code);
    // Auto-submit the moment the 4th digit lands — no need to wait for a
    // manual tap on "تأكيد". `_loading` guard stops a stray re-trigger (e.g.
    // editing a digit again) from firing a second request mid-flight.
    if (code.length == 4 && !_loading) {
      FocusScope.of(context).unfocus();
      _verify();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF4F5F3),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const OtpHeader(),
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
                    LocaleKeys.otp_title.tr(),
                    fontSize: 24,
                    color: const Color(0xFF17212B),
                    fontWeight: FontWeight.w700,
                  ),
                  6.height,
                  Wrap(
                    children: [
                      AppText(
                        '${LocaleKeys.otp_subtitle.tr()} ',
                        fontSize: 13,
                        color: const Color(0xFF9AA19C),
                        fontWeight: FontWeight.w500,
                      ),
                      AppText(
                        widget.phone,
                        fontSize: 13,
                        color: const Color(0xFF17212B),
                        fontWeight: FontWeight.w700,
                      ),
                    ],
                  ),
                  28.height,
                  OtpCodeRow(onChanged: _onCodeChanged),
                  20.height,
                  OtpResendTimer(onResend: _resend),
                  28.height,
                  CustomButton(
                    title: LocaleKeys.otp_verify.tr(),
                    loading: _loading,
                    onTap: _verify,
                  ),
                  20.height,
                  Center(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: AppText(
                        LocaleKeys.otp_changeNumber.tr(),
                        fontSize: 14,
                        color: AppColors.accentGold.themeColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  50.height,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
