import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_constants.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_text.dart';

class OwnerOnlyHint extends StatelessWidget {
  const OwnerOnlyHint({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: 14.paddingAll,
      decoration: BoxDecoration(
        color: AppColors.infoColor.themeColor.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius.r),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 18,
            color: AppColors.infoColor.themeColor,
          ),
          10.width,
          Expanded(
            child: AppText(
              LocaleKeys.subscription_ownerOnlyHint.tr(),
              fontSize: 12,
              height: 1.5,
              color: AppColors.textSecondaryColor.themeColor,
            ),
          ),
        ],
      ),
    );
  }
}
