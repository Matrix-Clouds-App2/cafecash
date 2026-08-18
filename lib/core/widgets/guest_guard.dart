import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../app/router/navigation_services.dart';
import '../../app/router/routes.dart';
import '../utils/app_colors.dart';
import '../utils/app_constants.dart';
import '../utils/locale_keys.dart';
import 'app_confirm_dialog.dart';

class GuestGuard {
  GuestGuard._();

  static bool ensureLoggedIn([BuildContext? context]) {
    if (!kIsGuest) return true;

    final dialogContext =
        context ?? NavigationService.navigationKey.currentContext!;

    AppConfirmDialog.show(
      dialogContext,
      icon: Icons.lock_outline_rounded,
      iconColor: AppColors.primaryColor.themeColor,
      title: LocaleKeys.guest_dialogTitle.tr(),
      message: LocaleKeys.guest_dialogMessage.tr(),
      confirmLabel: LocaleKeys.guest_dialogConfirm.tr(),
      onConfirm: () {
        NavigationService.goBack();
        NavigationService.push(Routes.loginScreen);
      },
    );
    return false;
  }
}
