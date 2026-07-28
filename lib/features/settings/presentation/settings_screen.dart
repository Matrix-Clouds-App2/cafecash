import 'package:easy_localization/easy_localization.dart';
import 'package:coffee_shop/core/extensions/extensions.dart';
import 'package:coffee_shop/core/widgets/app_button.dart';
import 'package:coffee_shop/core/widgets/app_text.dart';
import 'package:coffee_shop/core/widgets/custom_tap_effect.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/router/routes.dart';
import '../../../core/di/injection.dart';
import '../../../core/storage/local_storage.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_constants.dart';
import '../../../core/utils/locale_keys.dart';
import '../../auth/logic/auth_cubit.dart';
import '../../profile/logic/profile_cubit.dart';
String? kLang;
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = AppColors.primaryColor.themeColor;
    final isGuest = kIsGuest;
    final items = [
      // _SettingsItem(
      //   icon: Icons.person_outline_rounded,
      //   label: LocaleKeys.settings_updateProfile.tr(),
      //   subLabel: LocaleKeys.settings_updateProfileSubtitle.tr(),
      //   color: const Color(0xFF5B7FFF),
      //   onTap: () => Navigator.pushNamed(context, Routes.updateProfileScreen),
      // ),
      // _SettingsItem(
      //   icon: Icons.lock_outline_rounded,
      //   label: LocaleKeys.settings_changePassword.tr(),
      //   subLabel: LocaleKeys.settings_changePasswordSubtitle.tr(),
      //   color: const Color(0xFFFFB84D),
      //   onTap: () => Navigator.pushNamed(context, Routes.changePasswordScreen),
      // ),

      _SettingsItem(
        icon: Icons.headset_mic_outlined,
        label: LocaleKeys.settings_contactUs.tr(),
        subLabel: LocaleKeys.settings_contactUsSubtitle.tr(),
        color: const Color(0xFF26A69A),
        onTap: () => Navigator.pushNamed(context, Routes.contactUsScreen),
      ),
      _SettingsItem(
        icon: Icons.gavel_rounded,
        label: LocaleKeys.settings_terms.tr(),
        subLabel: LocaleKeys.settings_termsSubtitle.tr(),
        color: const Color(0xFF7E57C2),
        onTap: () => Navigator.pushNamed(context, Routes.termsScreen),
      ),
      // _SettingsItem(
      //   icon: Icons.language_rounded,
      //   label: LocaleKeys.settings_changeLanguage.tr(),
      //   subLabel: LocaleKeys.settings_changeLanguageSubtitle.tr(),
      //   color:AppColors.primaryColor.themeColor,
      //   onTap: () => _showLanguageSheet(context),
      // ),
      if (!isGuest)

        _SettingsItem(
        icon: Icons.logout_rounded,
        label: LocaleKeys.settings_logout.tr(),
        subLabel: LocaleKeys.settings_logoutSubtitle.tr(),
        color: const Color(0xFFFF5722),
        onTap: () => _showLogoutDialog(context),
      ),
      if (!isGuest)

        _SettingsItem(
        icon: Icons.delete_outline_rounded,
        label: LocaleKeys.settings_deleteAccount.tr(),
        subLabel: LocaleKeys.settings_deleteAccountSubtitle.tr(),
        color: const Color(0xFFD32F2F),
        onTap: () => _showDeleteDialog(context),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.settings_title.tr()),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: 16.paddingHorizontal,
        child: Column(
          children: [
            24.height,
            // ── Header card ────────────────────────────────────────────────
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  margin: 12.paddingBottom,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.themeColor
                        .withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 5,
                        offset: const Offset(4, 6),
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        LocaleKeys.settings_title.tr(),
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 18.sp,
                      ),
                      5.height,
                      AppText(
                        LocaleKeys.settings_headerSubtitle.tr(),
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 13.sp,
                      ),
                      5.height,
                    ],
                  ),
                ),
                PositionedDirectional(
                  top: -40.h,
                  end: -45.w,
                  child: Container(
                    width: 110.h,
                    height: 120.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.accentGold.themeColor
                          .withValues(alpha: 0.12),
                    ),
                  ),
                ),
              ],
            ),
            const _PrayerNotifSwitchTile(),
            12.height,
            ...items.map((item) => _SettingsTile(item: item)),
            24.height,
          ],
        ),
      ),
    );
  }

  // ── Language Bottom Sheet ─────────────────────────────────────────────────



  // ── Logout Dialog ─────────────────────────────────────────────────────────

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => _ConfirmDialog(
        icon: Icons.logout_rounded,
        iconColor: const Color(0xFFFF5722),
        title: LocaleKeys.settings_logoutDialogTitle.tr(),
        message: LocaleKeys.settings_logoutDialogMessage.tr(),
        confirmLabel: LocaleKeys.settings_logout.tr(),
        cancelLabel: LocaleKeys.common_cancel.tr(),
        confirmColor: const Color(0xFFFF5722),
        onConfirm: () {
          Navigator.pop(context);
          kUserModel=null;
          context.read<ProfileCubit>().reset();
          context.read<AuthCubit>().logout();
          Navigator.pushNamedAndRemoveUntil(
              context, Routes.loginScreen, (_) => false);
        },
      ),
    );
  }

  // ── Delete Account Dialog ─────────────────────────────────────────────────

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => _ConfirmDialog(
        icon: Icons.delete_forever_rounded,
        iconColor: const Color(0xFFD32F2F),
        title: LocaleKeys.settings_deleteDialogTitle.tr(),
        message: LocaleKeys.settings_deleteDialogMessage.tr(),
        confirmLabel: LocaleKeys.settings_deleteAccount.tr(),
        cancelLabel: LocaleKeys.common_cancel.tr(),
        confirmColor: const Color(0xFFD32F2F),
        onConfirm: () {
          // TODO: replace with delete account API when available
          Navigator.pop(context);
          context.read<ProfileCubit>().reset();
          context.read<AuthCubit>().logout();
          Navigator.pushNamedAndRemoveUntil(
              context, Routes.loginScreen, (_) => false);
        },
      ),
    );
  }
}

// ── Settings Tile ─────────────────────────────────────────────────────────────

class _SettingsItem {
  const _SettingsItem({
    required this.icon,
    required this.label,
    required this.subLabel,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String subLabel;
  final Color color;
  final VoidCallback onTap;
}
void showLanguageSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _LanguageSheet(parentContext: context),
  );
}
class _SettingsTile extends StatelessWidget {
  const _SettingsTile({required this.item});

  final _SettingsItem item;

  @override
  Widget build(BuildContext context) {
    return CustomTapEffect(
      onTap: item.onTap,
      child: Container(
        margin: 12.paddingBottom,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade50),
          borderRadius:
              BorderRadius.circular(AppConstants.cardBorderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 5,
              offset: const Offset(2, 2),
              spreadRadius: 2,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: item.color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(item.icon, color: item.color, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    item.label,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimaryColor.themeColor,
                  ),
                  3.height,
                  AppText(
                    item.subLabel,
                    fontSize: 10,
                    fontWeight: FontWeight.w300,
                    color: AppColors.textSecondaryColor.themeColor,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColors.textSecondaryColor.themeColor,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Prayer Notifications Switch Tile ─────────────────────────────────────────

class _PrayerNotifSwitchTile extends StatefulWidget {
  const _PrayerNotifSwitchTile();

  @override
  State<_PrayerNotifSwitchTile> createState() => _PrayerNotifSwitchTileState();
}

class _PrayerNotifSwitchTileState extends State<_PrayerNotifSwitchTile> {
  late bool _enabled;
  final _storage = getIt<LocalStorage>();

  @override
  void initState() {
    super.initState();
    _enabled = _storage.prayerNotificationsEnabled;
  }



  @override
  Widget build(BuildContext context) {
    final color = AppColors.primaryColor.themeColor;
    return Container(
      margin: 12.paddingBottom,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade50),
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 5,
            offset: const Offset(2, 2),
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.notifications_outlined, color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  'تفعيل إشعارات الصلوات',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimaryColor.themeColor,
                ),
                3.height,
                AppText(
                  'استقبل تنبيهاً عند حلول وقت كل صلاة',
                  fontSize: 10,
                  fontWeight: FontWeight.w300,
                  color: AppColors.textSecondaryColor.themeColor,
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }
}

// ── Language Bottom Sheet ─────────────────────────────────────────────────────

class _LanguageSheet extends StatefulWidget {
  const _LanguageSheet({required this.parentContext});

  final BuildContext parentContext;

  @override
  State<_LanguageSheet> createState() => _LanguageSheetState();
}

class _LanguageSheetState extends State<_LanguageSheet> {
  late String _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.parentContext.locale.languageCode;
  }

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 32.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Drag handle ─────────────────────────────────────────────────
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: primary,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ),
          16.height,

          // ── Title row ───────────────────────────────────────────────────
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 36.r,
                  height: 36.r,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.close_rounded,
                      size: 18.sp,
                      color: AppColors.textSecondaryColor.themeColor),
                ),
              ),
              const Spacer(),
              AppText(
                LocaleKeys.settings_languageTitle.tr(),
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimaryColor.themeColor,
              ),
              const Spacer(),
              SizedBox(width: 36.r),
            ],
          ),
          20.height,

          // ── Arabic option ────────────────────────────────────────────────
          _LangOption(
            flag: '🇸🇦',
            label: LocaleKeys.settings_arabic.tr(),
            isSelected: _selected == 'ar',
            onTap: () => setState(() => _selected = 'ar'),
          ),
          12.height,

          // ── English option ────────────────────────────────────────────────
          _LangOption(
            flag: '🇬🇧',
            label: LocaleKeys.settings_english.tr(),
            isSelected: _selected == 'en',
            onTap: () => setState(() => _selected = 'en'),
          ),
          24.height,

          // ── Confirm button ───────────────────────────────────────────────
          CustomButton(
            onTap: ()async{
              Navigator.pop(context);

              /// 1️⃣ خزّن اللغة الأول
              await getIt<LocalStorage>().setLang(_selected);

              /// 2️⃣ غيّر لغة الـ UI
              widget.parentContext.setLocale(Locale(_selected));

              /// 3️⃣ روح للـ Splash
              Navigator.pushNamedAndRemoveUntil(
              widget.parentContext,
              Routes.splashScreen,
              (_) => false,
              );
            },
            title: LocaleKeys.common_confirm.tr(),
          ),
        ],
      ),
    );
  }
}

class _LangOption extends StatelessWidget {
  const _LangOption({
    required this.flag,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String flag;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;

    return CustomTapEffect(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: isSelected
              ? primary.withValues(alpha: 0.06)
              : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: isSelected ? primary : Colors.grey.shade200,
            width: isSelected ? 1.8 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Text(flag, style: TextStyle(fontSize: 26.sp)),
            14.width,
            AppText(
              label,
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: isSelected
                  ? primary
                  : AppColors.textPrimaryColor.themeColor,
            ),
            const Spacer(),
            if (isSelected)
              Icon(Icons.check_circle_rounded, color: primary, size: 22.sp)
            else
              Icon(Icons.radio_button_unchecked_rounded,
                  color: Colors.grey.shade300, size: 22.sp),
          ],
        ),
      ),
    );
  }
}

// ── Confirm Dialog ────────────────────────────────────────────────────────────

class _ConfirmDialog extends StatelessWidget {
  const _ConfirmDialog({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.message,
    required this.confirmLabel,
    required this.cancelLabel,
    required this.confirmColor,
    required this.onConfirm,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String message;
  final String confirmLabel;
  final String cancelLabel;
  final Color confirmColor;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.r),
      ),
      backgroundColor: Colors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 28.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Icon circle ────────────────────────────────────────────────
            Container(
              width: 68.r,
              height: 68.r,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 32.sp),
            ),
            18.height,

            // ── Title ──────────────────────────────────────────────────────
            AppText(
              title,
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimaryColor.themeColor,
              textAlign: TextAlign.center,
            ),
            10.height,

            // ── Message ────────────────────────────────────────────────────
            AppText(
              message,
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondaryColor.themeColor,
              textAlign: TextAlign.center,
            ),
            28.height,

            // ── Buttons ────────────────────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    onTap: () => Navigator.pop(context),
                    title: cancelLabel,
                    isOutlined: true,
                    borderColor: Colors.grey.shade300,
                    textColor: AppColors.textSecondaryColor.themeColor,
                    color: Colors.transparent,
                  ),
                ),
                12.width,
                Expanded(
                  child: CustomButton(
                    onTap: onConfirm,
                    title: confirmLabel,
                    color: confirmColor,
                    borderColor: confirmColor,
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

