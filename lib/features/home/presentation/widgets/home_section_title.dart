import 'package:coffee_shop/core/extensions/extensions.dart';
import 'package:coffee_shop/core/utils/app_colors.dart';
import 'package:coffee_shop/core/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Reusable right-aligned section title raw used throughout the Home screen.
///
/// ```dart
/// HomeSectionTitle(
///   title: 'تاريخ انطلاق المنتدى',
///   icon: Icons.access_time_rounded,
/// )
/// ```
class HomeSectionTitle extends StatelessWidget {
  const HomeSectionTitle({
    super.key,
    required this.title,
    this.icon,
    this.subtitle,
  });

  final String title;
  final IconData? icon;

  /// Optional smaller subtitle line rendered below the title.
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.primaryColor.themeColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.r),
              topRight: Radius.circular(24.r),
            ),
          ),
          padding: 12.paddingVert + 16.paddingHorizontal+2.paddingBottom,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Icon on the leading side (left in LTR, right-most in RTL Row)


              // Title aligned to the end (right in RTL)
              AppText(
                title,
                fontSize: 14.sp,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
              if (icon != null)
                Icon(icon, color: Colors.yellow, size: 20.sp)
              else
                const SizedBox.shrink(),
            ],
          ),
        ),
        if (subtitle != null) ...[
          12.verticalSpace,
          Padding(
            padding: 16.paddingHorizontal,
            child: AppText(
              subtitle!,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondaryColor.themeColor,
            ),
          ),
        ],
      ],
    );
  }
}

