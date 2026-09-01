import 'package:app_base/core/utils/app_images.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../extensions/extensions.dart';
import '../utils/app_colors.dart';
import '../utils/locale_keys.dart';
import 'app_button.dart';
import 'app_text.dart';

class AppConfirmDialog extends StatelessWidget {
  const AppConfirmDialog({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.message,
    required this.confirmLabel,
    required this.onConfirm,
    this.cancelLabel,
    this.confirmColor,
    this.showCancelButton = true,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String message;
  final String confirmLabel;
  final String? cancelLabel;
  final Color? confirmColor;
  final bool showCancelButton;
  final VoidCallback onConfirm;

  static Future<T?> show<T>(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String message,
    required String confirmLabel,
    required VoidCallback onConfirm,
    String? cancelLabel,
    Color? confirmColor,
    bool showCancelButton = true,
  }) {
    return showDialog<T>(
      context: context,
      builder: (_) => AppConfirmDialog(
        icon: icon,
        iconColor: iconColor,
        title: title,
        message: message,
        confirmLabel: confirmLabel,
        onConfirm: onConfirm,
        cancelLabel: cancelLabel,
        confirmColor: confirmColor,
        showCancelButton: showCancelButton,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final confirm = confirmColor ?? AppColors.primaryColor.themeColor;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
      backgroundColor: AppColors.cardColor.themeColor,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 28.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
           Image.asset(AppImages.visitor),
            18.height,
            AppText(
              title,
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimaryColor.themeColor,
              textAlign: TextAlign.center,
            ),
            10.height,
            AppText(
              message,
              fontSize: 13,
              color: AppColors.textSecondaryColor.themeColor,
              textAlign: TextAlign.center,
            ),
            28.height,
            Row(
              children: [
                if (showCancelButton) ...[
                  Expanded(
                    child: CustomButton(
                      onTap: () => Navigator.pop(context),
                      title: cancelLabel ?? LocaleKeys.common_cancel.tr(),
                      isOutlined: true,
                      borderColor: AppColors.dividerColor.themeColor,
                      textColor: AppColors.textSecondaryColor.themeColor,
                      color: Colors.transparent,
                    ),
                  ),
                  12.width,
                ],
                Expanded(
                  child: CustomButton(
                    onTap: onConfirm,
                    title: confirmLabel,
                    color: confirm,
                    borderColor: confirm,
                    textColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
