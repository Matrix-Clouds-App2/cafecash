import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/router/routes.dart';
import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/image/custom_image.dart';
import '../../../profile/logic/profile_cubit.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key});

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
          color: AppColors.cardColor.themeColor,
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
