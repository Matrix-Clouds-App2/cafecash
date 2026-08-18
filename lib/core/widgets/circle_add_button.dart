import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_colors.dart';
import 'custom_tap_effect.dart';

class CircleAddButton extends StatelessWidget {
  const CircleAddButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.textPrimaryColor.themeColor;

    return CustomTapEffect(
      onTap: onTap,
      child: Container(
        width: 58.w,
        height: 58.w,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.lerp(primary, Colors.white, 0.2)!,
              primary,
            ],
          ),
          boxShadow: [
            // Contact shadow — keeps it grounded.
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.10),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
            // Soft colored glow — lifts it off the page.
            BoxShadow(
              color: primary.withValues(alpha: 0.4),
              blurRadius: 18,
              offset: const Offset(0, 8),
              spreadRadius: -4,
            ),
          ],
        ),
        child: Icon(Icons.add_rounded, color: Colors.white, size: 30.sp),
      ),
    );
  }
}
