import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_colors.dart';

class NotificationBellIcon extends StatelessWidget {
  const NotificationBellIcon({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Icon(
            Icons.notifications_none_rounded,
            size: 24.sp,
            color: AppColors.textPrimaryColor.themeColor,
          ),
          PositionedDirectional(
            top: -2,
            end: -2,
            child: Container(
              width: 8.w,
              height: 8.w,
              decoration: BoxDecoration(
                color: AppColors.errorColor.themeColor,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.backgroundColor.themeColor,
                  width: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
