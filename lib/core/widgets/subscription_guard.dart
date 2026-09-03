import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../app/router/navigation_services.dart';
import '../../app/router/routes.dart';
import '../utils/app_colors.dart';
import '../utils/app_constants.dart';
import '../utils/locale_keys.dart';
import 'app_confirm_dialog.dart';

class SubscriptionGuard {
  SubscriptionGuard._();

  static bool ensureActive([BuildContext? context]) {
    if (!kSubscriptionLocked) return true;

    final dialogContext =
        context ?? NavigationService.navigationKey.currentContext!;

    AppConfirmDialog.show(
      dialogContext,
      icon: Icons.workspace_premium_outlined,
      iconColor: AppColors.errorColor.themeColor,
      title: LocaleKeys.subscription_lockedDialogTitle.tr(),
      message: LocaleKeys.subscription_lockedDialogMessage.tr(),
      confirmLabel: LocaleKeys.subscription_lockedDialogConfirm.tr(),
      confirmColor: AppColors.primaryColor.themeColor,
      onConfirm: () {
        NavigationService.goBack();
        NavigationService.push(Routes.subscriptionScreen);
      },
    );
    return false;
  }
}
