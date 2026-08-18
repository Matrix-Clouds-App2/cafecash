import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/custom_tap_effect.dart';

/// A "-  N  +" quantity control shared by the order-builder sheet and the
/// order-details screen.
class OrderStepper extends StatelessWidget {
  const OrderStepper({
    super.key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _StepButton(
          icon: Icons.add_rounded,
          color: AppColors.successColor.themeColor,
          onTap: onIncrement,
        ),
        SizedBox(
          width: 30.w,
          child: AppText(
            '$quantity',
            textAlign: TextAlign.center,
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimaryColor.themeColor,
          ),
        ),
        _StepButton(
          icon: Icons.remove_rounded,
          color: AppColors.disabledColor.themeColor,
          onTap: onDecrement,
        ),
      ],
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return CustomTapEffect(
      onTap: onTap,
      child: Container(
        width: 26.r,
        height: 26.r,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        child: Icon(icon, color: Colors.white, size: 15.sp),
      ),
    );
  }
}
