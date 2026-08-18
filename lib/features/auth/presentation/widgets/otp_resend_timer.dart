import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_text.dart';

class OtpResendTimer extends StatefulWidget {
  const OtpResendTimer({super.key, this.seconds = 60, this.onResend});

  final int seconds;
  final VoidCallback? onResend;

  @override
  State<OtpResendTimer> createState() => _OtpResendTimerState();
}

class _OtpResendTimerState extends State<OtpResendTimer> {
  late int _secondsLeft;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _secondsLeft = widget.seconds;
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft <= 1) {
        timer.cancel();
        setState(() => _secondsLeft = 0);
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  void _resend() {
    widget.onResend?.call();
    setState(() => _secondsLeft = widget.seconds);
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_secondsLeft == 0) {
      return GestureDetector(
        onTap: _resend,
        child: AppText(
          LocaleKeys.otp_resend.tr(),
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: AppColors.accentGold.themeColor,
        ),
      );
    }

    return AppText(
      LocaleKeys.otp_resendIn.tr(namedArgs: {'seconds': '$_secondsLeft'}),
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: const Color(0xFF9AA19C),
    );
  }
}
