import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_constants.dart';
import '../../../../core/utils/app_images.dart';
import '../../../../core/widgets/app_text.dart';

class ShiftBrandingFooter extends StatelessWidget {
  const ShiftBrandingFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(color: AppColors.dividerColor.themeColor, height: 1),
        16.height,
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: Image.asset(
                AppImages.logo,
                width: 34.w,
                height: 34.w,
                fit: BoxFit.cover,
              ),
            ),
            10.width,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    AppConstants.appName,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimaryColor.themeColor,
                  ),
                  2.height,
                  AppText(
                    AppConstants.storeUrl,
                    fontSize: 10,
                    color: AppColors.textSecondaryColor.themeColor,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
