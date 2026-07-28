import 'package:easy_localization/easy_localization.dart';
import 'package:app_base/core/extensions/extensions.dart';
import 'package:app_base/core/widgets/app_button.dart';
import 'package:app_base/core/widgets/app_text.dart';
import 'package:app_base/core/widgets/custom_tap_effect.dart';
import 'package:app_base/core/widgets/image/custom_image.dart';
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

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  List<_MoreItem> _items(BuildContext context, {required bool isGuest}) => [
        _MoreItem(
          icon: Icons.language_rounded,
          subLabel: LocaleKeys.settings_changeLanguageSubtitle.tr(),
          label: LocaleKeys.settings_changeLanguage.tr(),
          color: AppColors.primaryColor.themeColor,
          onTap: () => _showLanguageSheet(context),
        ),
        if (!isGuest)
          _MoreItem(
            icon: Icons.logout_rounded,
            subLabel: LocaleKeys.settings_logoutSubtitle.tr(),
            label: LocaleKeys.settings_logout.tr(),
            color: const Color(0xFFFF5722),
            onTap: () => _showLogoutDialog(context),
          ),
      ];

  @override
  Widget build(BuildContext context) {
    final primaryColor = AppColors.primaryColor.themeColor;

    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.more_title.tr()),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: 16.paddingHorizontal,
        child: Column(
          children: [
            24.height,
            _ProfileCard(),
            16.height,
            BlocSelector<ProfileCubit, ProfileState, bool>(
              selector: (state) => state is! ProfileSuccess,
              builder: (context, isGuest) {
                final items = _items(context, isGuest: isGuest);
                return Column(
                  children: [
                    ...items.map((item) => _MoreTile(item: item)),
                  ],
                );
              },
            ),
            24.height,
          ],
        ),
      ),
    );
  }
}

void _showLanguageSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _LanguageSheet(parentContext: context),
  );
}

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
        context.read<ProfileCubit>().reset();
        context.read<AuthCubit>().logout();
        Navigator.pushNamedAndRemoveUntil(
            context, Routes.loginScreen, (_) => false);
      },
    ),
  );
}

// ── Profile card widget ───────────────────────────────────────────────────────

class _ProfileCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;
    final title = LocaleKeys.profile_title.tr();
    final subtitle = LocaleKeys.more_profileCardSubtitle.tr();

    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoading) {
          return _ProfileCardShell(
            leading: _ProfileLeadingIcon(primary: primary),
            title: AppText(
              title,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimaryColor.themeColor,
            ),
            subtitle: AppText(
              subtitle,
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondaryColor.themeColor,
            ),
            trailing: const SizedBox.shrink(),
            onTap: null,
          );
        }

        if (state is ProfileSuccess) {
          final user = state.user;
          final displayName = user.name.trim().isNotEmpty ? user.name : title;
          return _ProfileCardShell(
            leading: _ProfileLeadingAvatar(
              primary: primary,
              imageUrl: user.avatar,
              name: user.name,
            ),
            title: AppText(
              displayName,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimaryColor.themeColor,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: AppText(
              subtitle,
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondaryColor.themeColor,
            ),
            trailing: const SizedBox.shrink(),
            onTap: null,
          );
        }

        // Error or Initial — guest state
        return _ProfileCardShell(
          leading: _ProfileLeadingIcon(primary: primary),
          title: AppText(
            title,
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimaryColor.themeColor,
          ),
          subtitle: AppText(
            subtitle,
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: AppColors.textSecondaryColor.themeColor,
          ),
          trailing: TextButton(
            onPressed: () => Navigator.pushNamed(context, Routes.loginScreen),
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              backgroundColor: primary.withValues(alpha: 0.08),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            child: AppText(
              LocaleKeys.profile_loginNow.tr(),
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: primary,
            ),
          ),
          onTap: null,
        );
      },
    );
  }
}

class _ProfileLeadingIcon extends StatelessWidget {
  const _ProfileLeadingIcon({required this.primary});

  final Color primary;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44.r,
      height: 44.r,
      decoration: BoxDecoration(
        color: primary.withValues(alpha: 0.12),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.person_outline_rounded,
        color: primary,
        size: 22.sp,
      ),
    );
  }
}

class _ProfileLeadingAvatar extends StatelessWidget {
  const _ProfileLeadingAvatar({
    required this.primary,
    required this.imageUrl,
    required this.name,
  });

  final Color primary;
  final String? imageUrl;
  final String name;

  String get _initials {
    final words = name
        .trim()
        .split(' ')
        .where((word) => word.isNotEmpty)
        .take(2)
        .toList();
    if (words.isEmpty) return '?';
    return words.map((word) => word[0].toUpperCase()).join();
  }

  @override
  Widget build(BuildContext context) {
    if (imageUrl != null && imageUrl!.trim().isNotEmpty) {
      return CustomImage(
        image: imageUrl!.trim(),
        width: 44.r,
        height: 44.r,
        radius: 999.r,
        fit: BoxFit.cover,
      );
    }

    return Container(
      width: 44.r,
      height: 44.r,
      decoration: BoxDecoration(
        color: primary.withValues(alpha: 0.12),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: AppText(
        _initials,
        fontSize: 14.sp,
        fontWeight: FontWeight.w700,
        color: primary,
      ),
    );
  }
}

class _ProfileCardShell extends StatelessWidget {
  const _ProfileCardShell({
    required this.leading,
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.onTap,
  });

  final Widget leading;
  final Widget title;
  final Widget subtitle;
  final Widget trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.07),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            leading,
            14.width,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [title, 3.height, subtitle],
              ),
            ),
            8.width,
            trailing,
          ],
        ),
      ),
    );
  }
}

// ── More tile ─────────────────────────────────────────────────────────────────

class _MoreItem {
  const _MoreItem({
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

class _MoreTile extends StatelessWidget {
  const _MoreTile({required this.item});

  final _MoreItem item;

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
          borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 5,
              offset: const Offset(2, 2),
              spreadRadius: 2,
            )
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
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppText(item.label,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimaryColor.themeColor),
                  if (item.subLabel.isNotEmpty) ...[
                    3.height,
                    AppText(item.subLabel,
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                        color: AppColors.textSecondaryColor.themeColor),
                  ]
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

// ── Language bottom sheet ─────────────────────────────────────────────────────

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
          _LangOption(
            flag: '🇸🇦',
            label: LocaleKeys.settings_arabic.tr(),
            isSelected: _selected == 'ar',
            onTap: () => setState(() => _selected = 'ar'),
          ),
          12.height,
          _LangOption(
            flag: '🇬🇧',
            label: LocaleKeys.settings_english.tr(),
            isSelected: _selected == 'en',
            onTap: () => setState(() => _selected = 'en'),
          ),
          24.height,
          CustomButton(
            onTap: () async {
              Navigator.pop(context);
              await getIt<LocalStorage>().setLang(_selected);
              widget.parentContext.setLocale(Locale(_selected));
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

// ── Confirm dialog ─────────────────────────────────────────────────────────────

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
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondaryColor.themeColor,
              textAlign: TextAlign.center,
            ),
            28.height,
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
