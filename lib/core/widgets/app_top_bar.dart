import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../extensions/extensions.dart';
import '../utils/app_colors.dart';
import 'app_text.dart';
import 'notification_bell_icon.dart';

class AppTopBar extends StatelessWidget {
  const AppTopBar({
    super.key,
    required this.title,
    this.onMenuTap,
    this.onNotificationTap,
    this.titleWidget,
    this.actions,
  });

  final String title;
  final VoidCallback? onMenuTap;
  final VoidCallback? onNotificationTap;

  final Widget? titleWidget;

  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.backgroundColor.themeColor,
      child: SafeArea(
        bottom: false,
        child: Container(
          padding: 16.paddingHorizontal + 16.paddingBottom + 3.paddingTop,
          child: Row(
            children: [
              GestureDetector(
                onTap: onMenuTap,
                child: Icon(
                  Icons.menu_rounded,
                  size: 24.sp,
                  color: AppColors.textPrimaryColor.themeColor,
                ),
              ),
              Expanded(
                child: titleWidget ??
                    AppText(
                      title,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      textAlign: TextAlign.center,
                      color: AppColors.textPrimaryColor.themeColor,
                    ),
              ),
              if (actions != null)
                Row(mainAxisSize: MainAxisSize.min, children: actions!)
              // else
              //   NotificationBellIcon(onTap: onNotificationTap),
            ],
          ),
        ),
      ),
    );
  }
}
