import 'package:easy_localization/easy_localization.dart';
import 'package:app_base/core/extensions/extensions.dart';
import 'package:app_base/core/widgets/app_text.dart';
import 'package:app_base/core/widgets/custom_tap_effect.dart';
import 'package:app_base/core/widgets/image/custom_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/network/api_endpoints.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_constants.dart';
import '../../../core/utils/helper_methods.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../app/router/routes.dart';
import '../../../features/profile/logic/profile_cubit.dart';
import '../../settings/presentation/settings_screen.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  List<_MoreItem> _items(BuildContext context, {required bool isGuest}) => [
        if (!isGuest)
          _MoreItem(
            icon: Icons.bookmark_added_outlined,
            subLabel: LocaleKeys.more_myBookingsSubtitle.tr(),
            label: LocaleKeys.more_myBookings.tr(),
            color: AppColors.primaryColor.themeColor,
            onTap: () =>
                Navigator.pushNamed(context, Routes.myBookedSessionsScreen),
          ),
        _MoreItem(
          icon: Icons.event_note_outlined,
          subLabel: LocaleKeys.more_exhibitorsSubtitle.tr(),
          label: LocaleKeys.more_exhibitors.tr(),
          color: const Color(0xFF5B7FFF),
          onTap: () => Navigator.pushNamed(context, Routes.exhibitorsScreen),
        ),
        _MoreItem(
          subLabel: LocaleKeys.more_exploreSubtitle.tr(),
          icon: Icons.apartment_outlined,
          label: LocaleKeys.more_explore.tr(),
          color: const Color(0xFF4DA6FF),
          onTap: () => Navigator.pushNamed(context, Routes.exploreScreen),
        ),
        _MoreItem(
          subLabel: LocaleKeys.more_indoorNavigate.tr(),
          icon: Icons.map_outlined,
          color: AppColors.accentGold.themeColor,
          label: LocaleKeys.more_map.tr(),
          // color: const Color(0xFF6B5BCB),
          onTap: () =>
              Navigator.pushNamed(context, Routes.expoMapScreen)
        ),
        _MoreItem(
          subLabel: LocaleKeys.more_prayerSubtitle.tr(),
          icon: Icons.access_time_outlined,
          label: LocaleKeys.more_prayer.tr(),
          color: const Color(0xFF26C6C6),
          onTap: () => Navigator.pushNamed(context, Routes.prayerTimingsScreen),
        ),
        _MoreItem(
          subLabel: LocaleKeys.more_embassySubtitle.tr(),
          icon: Icons.open_in_new_outlined,
          label: LocaleKeys.more_embassy.tr(),
          color: const Color(0xFF4CAF50),
          onTap: () {
            HelperMethods.openLink(ApiEndpoints.embassyUrl);
          },
        ),
        _MoreItem(
          subLabel: LocaleKeys.more_wuf13TablesSubtitle.tr(),
          icon: Icons.table_chart_outlined,
          label: LocaleKeys.more_wuf13Tables.tr(),
          color: const Color(0xFF5C6BC0),
          onTap: () => Navigator.pushNamed(context, Routes.wuf13TablesScreen),
        ),

          _MoreItem(
            subLabel: LocaleKeys.more_settingsSubtitle.tr(),
            icon: Icons.settings_outlined,
            label: LocaleKeys.more_settings.tr(),
            color: const Color(0xFF9C27B0),
            onTap: () => Navigator.pushNamed(context, Routes.settingsScreen),
          ),
        _MoreItem(
          subLabel: LocaleKeys.settings_changeLanguageSubtitle.tr(),
          icon: Icons.language_rounded,
          label: LocaleKeys.settings_changeLanguage.tr(),
          color: AppColors.primaryColor.themeColor,
          onTap: () {
            showLanguageSheet(context);
          },
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

            // // ── Links header card ──────────────────────────────────────────
            // Stack(
            //   children: [
            //     Container(
            //       width: double.infinity,
            //       margin: 12.paddingBottom,
            //       padding:
            //           const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            //       decoration: BoxDecoration(
            //         color: AppColors.primaryColor.themeColor
            //             .withValues(alpha: 0.9),
            //         borderRadius: BorderRadius.circular(20),
            //         boxShadow: [
            //           BoxShadow(
            //             color: Colors.black.withValues(alpha: 0.1),
            //             blurRadius: 5,
            //             offset: const Offset(4, 6),
            //             spreadRadius: 2,
            //           )
            //         ],
            //       ),
            //       child: Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           AppText(
            //             LocaleKeys.more_linksTitle.tr(),
            //             color: Colors.white,
            //             fontWeight: FontWeight.w600,
            //             fontSize: 18.sp,
            //           ),
            //           5.height,
            //           AppText(
            //             LocaleKeys.more_linksSubtitle.tr(),
            //             color: Colors.white,
            //             fontWeight: FontWeight.w400,
            //             fontSize: 13.sp,
            //           ),
            //           5.height,
            //         ],
            //       ),
            //     ),
            //     PositionedDirectional(
            //       top: -40.h,
            //       end: -45.w,
            //       child: Container(
            //         width: 110.h,
            //         height: 120.h,
            //         decoration: BoxDecoration(
            //           shape: BoxShape.circle,
            //           color: AppColors.accentGold.themeColor
            //               .withValues(alpha: 0.12),
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            // ── Profile card ───────────────────────────────────────────────
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
            trailing: Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16.sp,
              color: AppColors.textSecondaryColor.themeColor,
            ),
            onTap: () => Navigator.pushNamed(context, Routes.profileScreen),
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
                  if(item.subLabel.isNotEmpty)
                    ...[
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
