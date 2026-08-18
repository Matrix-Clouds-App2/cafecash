import 'package:app_base/core/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_images.dart';

/// OTP's own header — visually similar to the shared `PrimaryHeader` (gold
/// fill + soft decorative circle) but implemented independently so tweaking
/// it can never affect Login/Register/Home, which all render `PrimaryHeader`
/// directly.
class OtpHeader extends StatelessWidget {
  const OtpHeader({super.key, this.height});

  final double? height;

  @override
  Widget build(BuildContext context) {
    final resolvedHeight = height ?? MediaQuery.sizeOf(context).height * 0.33;

    return SizedBox(
      height: resolvedHeight,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ColoredBox(color: AppColors.primaryColor.themeColor),
          PositionedDirectional(
            top: (-65).h,
            end: (-55).w,
            child: Container(
              width: 170.h,
              height: 170.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.accentGold.themeColor.withValues(alpha: 0.12),
              ),
            ),
          ),
          SafeArea(
            child: Image.asset(
              AppImages.otp,
              // width: 220.w,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
