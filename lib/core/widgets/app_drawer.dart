import 'package:app_base/core/utils/app_images.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../app/router/navigation_services.dart';
import '../../app/router/routes.dart';
import '../../features/auth/logic/auth_cubit.dart';
import '../../features/profile/logic/profile_cubit.dart';
import '../../features/shift/logic/shift_cubit.dart';
import '../extensions/extensions.dart';
import '../utils/app_colors.dart';
import '../utils/app_overlay.dart';
import '../utils/locale_keys.dart';
import 'app_confirm_dialog.dart';
import 'app_text.dart';
import 'custom_tap_effect.dart';
import 'image/custom_image.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;

    return Drawer(
      backgroundColor: AppColors.backgroundColor.themeColor,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              color: primary,
              padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 24.h),
              child: const _DrawerHeader(),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                children: [
                  _DrawerTile(
                    icon: Icons.person_outline_rounded,
                    label: LocaleKeys.drawer_myAccount.tr(),
                    onTap: () => _navigate(Routes.moreScreen),
                  ),
                  _DrawerTile(
                    icon: Icons.task_alt_rounded,
                    label: LocaleKeys.drawer_closeShift.tr(),
                    onTap: _openCloseShift,
                  ),
                  _DrawerTile(
                    icon: Icons.history_rounded,
                    label: LocaleKeys.drawer_shifts.tr(),
                    onTap: () => _navigate(Routes.shiftHistoryScreen),
                  ),
                  const _DrawerDivider(),
                  _DrawerTile(
                    icon: Icons.people_alt_outlined,
                    label: LocaleKeys.drawer_customersManagement.tr(),
                    onTap: () => _navigate(Routes.customersScreen),
                  ),
                  _DrawerTile(
                    icon: Icons.restaurant_menu_rounded,
                    label: LocaleKeys.drawer_itemsManagement.tr(),
                    onTap: () => _navigate(Routes.categoriesScreen),
                  ),
                  _DrawerTile(
                    icon: Icons.account_balance_outlined,
                    label: LocaleKeys.drawer_deferredAccounts.tr(),
                    onTap: () => _navigate(Routes.deferredAccountsScreen),
                  ),
                  _DrawerTile(
                    icon: Icons.cancel_outlined,
                    label: LocaleKeys.drawer_cancelledOrders.tr(),
                    onTap: _openCancelledOrders,
                  ),
                  _DrawerTile(
                    icon: Icons.settings_outlined,
                    label: LocaleKeys.drawer_settings.tr(),
                    onTap: () => _navigate(Routes.settingsScreen),
                  ),
                  const _DrawerDivider(),
                  _DrawerTile(
                    icon: Icons.swap_horiz_rounded,
                    label: LocaleKeys.drawer_receiveShift.tr(),
                    onTap: () => _navigate(Routes.shiftStartScreen),
                  ),
                  _DrawerTile(
                    icon: Icons.output_rounded,
                    label: LocaleKeys.drawer_handoverShift.tr(),
                    onTap: _comingSoon,
                  ),
                  const _DrawerDivider(),
                  // _DrawerTile(
                  //   icon: Icons.privacy_tip_outlined,
                  //   label: LocaleKeys.drawer_usagePolicy.tr(),
                  //   onTap: _comingSoon,
                  // ),
                  _DrawerTile(
                    icon: Icons.logout_rounded,
                    label: LocaleKeys.settings_logout.tr(),
                    color: AppColors.errorColor.themeColor,
                    onTap: _confirmLogout,
                  ),
                  12.height,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void _navigate(String route, {Map<String, dynamic>? arguments}) {
    NavigationService.goBack();
    NavigationService.push(route, arguments: arguments);
  }

  static void _comingSoon() {
    NavigationService.goBack();
    AppOverlay.showSuccess(LocaleKeys.drawer_comingSoon.tr());
  }

  static void _openCloseShift() {
    final rootContext = NavigationService.navigationKey.currentContext!;
    final state = rootContext.read<ShiftCubit>().state;
    final active = state is ShiftReady ? state.active : null;

    NavigationService.goBack();
    if (active == null) {
      AppOverlay.showError(LocaleKeys.shift_noActiveShift.tr());
      return;
    }
    NavigationService.push(Routes.shiftSummaryScreen,
        arguments: {'shift': active});
  }

  static void _openCancelledOrders() {
    final rootContext = NavigationService.navigationKey.currentContext!;
    final state = rootContext.read<ShiftCubit>().state;
    final active = state is ShiftReady ? state.active : null;

    NavigationService.goBack();
    if (active == null) {
      AppOverlay.showError(LocaleKeys.shift_noActiveShift.tr());
      return;
    }
    NavigationService.push(Routes.shiftCancelledOrdersScreen,
        arguments: {'shift': active});
  }

  static void _confirmLogout() {
    NavigationService.goBack();
    final rootContext = NavigationService.navigationKey.currentContext!;
    AppConfirmDialog.show(
      rootContext,
      icon: Icons.logout_rounded,
      iconColor: AppColors.errorColor.themeColor,
      title: LocaleKeys.settings_logoutDialogTitle.tr(),
      message: LocaleKeys.settings_logoutDialogMessage.tr(),
      confirmLabel: LocaleKeys.settings_logout.tr(),
      confirmColor: AppColors.errorColor.themeColor,
      onConfirm: () {
        NavigationService.goBack();
        rootContext.read<ProfileCubit>().reset();
        rootContext.read<AuthCubit>().logout();
        NavigationService.pushNamedAndRemoveUntil(Routes.loginScreen);
      },
    );
  }
}

class _DrawerHeader extends StatelessWidget {
  const _DrawerHeader();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        final isGuest = state is! ProfileSuccess;
        final name = isGuest ? LocaleKeys.profile_title.tr() : state.user.name;
        final avatarUrl = isGuest ? null : state.user.avatar;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(
                AppImages.person,
                height: 120,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                20.height,
                AppText(
                  'كافية كاش',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                20.height,
                AppText(
                  name,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimaryColor.themeColor,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                // 6.height,
                if (isGuest)
                  CustomTapEffect(
                    onTap: () {
                      NavigationService.goBack();
                      NavigationService.push(Routes.loginScreen);
                    },
                    child: AppText(
                      LocaleKeys.profile_loginNow.tr(),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withValues(alpha: 0.85),
                    ),
                  )
                else
                  AppText(
                    state.user.phone,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color:
                        AppColors.textPrimaryColor.themeColor.withOpacity(0.8),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            )
          ],
        );
      },
    );
  }
}

class _HeaderAvatar extends StatelessWidget {
  const _HeaderAvatar({required this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final hasImage = imageUrl != null && imageUrl!.trim().isNotEmpty;

    return Container(
      width: 64.r,
      height: 64.r,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        shape: BoxShape.circle,
      ),
      clipBehavior: Clip.antiAlias,
      child: hasImage
          ? CustomImage(image: imageUrl!.trim(), fit: BoxFit.cover)
          : Icon(Icons.person_rounded, color: Colors.white, size: 34.sp),
    );
  }
}

class _DrawerTile extends StatelessWidget {
  const _DrawerTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final tileColor = color ?? AppColors.textPrimaryColor.themeColor;

    return CustomTapEffect(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 13.h),
        child: Row(
          children: [
            Icon(icon, size: 22.sp, color: tileColor),
            14.width,
            AppText(
              label,
              fontSize: 14.5,
              fontWeight: FontWeight.w600,
              color: tileColor,
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerDivider extends StatelessWidget {
  const _DrawerDivider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Divider(
        height: 1,
        thickness: 1,
        color: AppColors.dividerColor.themeColor,
      ),
    );
  }
}
