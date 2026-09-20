import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/router/navigation_services.dart';
import '../../../app/router/routes.dart';
import '../../../core/di/injection.dart';
import '../../../core/extensions/extensions.dart';
import '../../../core/storage/local_storage.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_constants.dart';
import '../../../core/utils/app_overlay.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/app_confirm_dialog.dart';
import '../../../core/widgets/guest_guard.dart';
import '../../profile/logic/profile_cubit.dart';
import '../../sync/presentation/logout_flow.dart';
import 'widgets/language_sheet.dart';
import 'widgets/settings_tile.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  void _toggleWalletPayment() {
    final enabled = !kWalletPaymentEnabled;
    setState(() => kWalletPaymentEnabled = enabled);
    getIt<LocalStorage>().setWalletPaymentEnabled(enabled);
  }

  List<SettingsItem> _items(BuildContext context, {required bool isGuest}) => [
        SettingsItem(
          icon: Icons.account_balance_wallet_outlined,
          label: LocaleKeys.settings_walletPaymentTitle.tr(),
          subLabel: LocaleKeys.settings_walletPaymentDescription.tr(),
          color: AppColors.primaryColor.themeColor,
          toggleValue: kWalletPaymentEnabled,
          onTap: _toggleWalletPayment,
        ),
        SettingsItem(
          icon: Icons.language_rounded,
          label: LocaleKeys.settings_changeLanguage.tr(),
          subLabel: LocaleKeys.settings_changeLanguageSubtitle.tr(),
          color: AppColors.primaryColor.themeColor,
          onTap: () => LanguageSheet.show(context),
        ),
        SettingsItem(
          icon: Icons.description_outlined,
          label: LocaleKeys.settings_termsConditions.tr(),
          subLabel: LocaleKeys.settings_termsConditionsSubtitle.tr(),
          color: AppColors.secondaryColor.themeColor,
          onTap: () => context.pushNamed(Routes.termsConditionsScreen),
        ),
        SettingsItem(
          icon: Icons.privacy_tip_outlined,
          label: LocaleKeys.settings_privacyPolicy.tr(),
          subLabel: LocaleKeys.settings_privacyPolicySubtitle.tr(),
          color: AppColors.infoColor.themeColor,
          onTap: () => context.pushNamed(Routes.privacyPolicyScreen),
        ),
        SettingsItem(
          icon: Icons.info_outline_rounded,
          label: LocaleKeys.settings_aboutUs.tr(),
          subLabel: LocaleKeys.settings_aboutUsSubtitle.tr(),
          color: AppColors.accentGold.themeColor,
          onTap: () => context.pushNamed(Routes.aboutUsScreen),
        ),
        SettingsItem(
          icon: Icons.workspace_premium_outlined,
          label: LocaleKeys.settings_subscriptionPlans.tr(),
          subLabel: LocaleKeys.settings_subscriptionPlansSubtitle.tr(),
          color: AppColors.accentGold.themeColor,
          onTap: () {
            if (GuestGuard.ensureLoggedIn(context)) {
              context.pushNamed(Routes.subscriptionScreen);
            }
          },
        ),
        if (!isGuest) ...[
          SettingsItem(
            icon: Icons.logout_rounded,
            label: LocaleKeys.settings_logout.tr(),
            subLabel: LocaleKeys.settings_logoutSubtitle.tr(),
            color: AppColors.warningColor.themeColor,
            onTap: () => _confirmLogout(context),
          ),
          SettingsItem(
            icon: Icons.delete_outline_rounded,
            label: LocaleKeys.settings_deleteAccount.tr(),
            subLabel: LocaleKeys.settings_deleteAccountSubtitle.tr(),
            color: AppColors.errorColor.themeColor,
            onTap: () => _confirmDeleteAccount(context),
          ),
        ],
      ];

  void _confirmLogout(BuildContext context) {
    AppConfirmDialog.show(
      context,
      icon: Icons.logout_rounded,
      iconColor: AppColors.warningColor.themeColor,
      title: LocaleKeys.settings_logoutDialogTitle.tr(),
      message: LocaleKeys.settings_logoutDialogMessage.tr(),
      confirmLabel: LocaleKeys.settings_logout.tr(),
      confirmColor: AppColors.warningColor.themeColor,
      onConfirm: () {
        NavigationService.goBack();
        performLogout();
      },
    );
  }

  void _confirmDeleteAccount(BuildContext context) {
    AppConfirmDialog.show(
      context,
      icon: Icons.delete_outline_rounded,
      iconColor: AppColors.errorColor.themeColor,
      title: LocaleKeys.settings_deleteAccountDialogTitle.tr(),
      message: LocaleKeys.settings_deleteAccountDialogMessage.tr(),
      confirmLabel: LocaleKeys.settings_deleteAccountConfirm.tr(),
      confirmColor: AppColors.errorColor.themeColor,
      onConfirm: () async {
        NavigationService.goBack();
        final success = await context.read<ProfileCubit>().deleteAccount();
        if (!success) return;

        await performLogout(isDeleteAccount: true);
        AppOverlay.showSuccess(LocaleKeys.settings_deleteAccountSuccess.tr());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;

    return Scaffold(
      backgroundColor: AppColors.surfaceColor.themeColor,
      appBar: AppBar(
        title: Text(LocaleKeys.drawer_settings.tr()),
        backgroundColor: primary,
        foregroundColor: AppColors.textPrimaryColor.themeColor,
      ),
      body: SingleChildScrollView(
        padding: 16.paddingAll,
        child: BlocSelector<ProfileCubit, ProfileState, bool>(
          selector: (state) => state is! ProfileSuccess,
          builder: (context, isGuest) {
            final items = _items(context, isGuest: isGuest);
            return Column(
              children: items.map((item) => SettingsTile(item: item)).toList(),
            );
          },
        ),
      ),
    );
  }
}
