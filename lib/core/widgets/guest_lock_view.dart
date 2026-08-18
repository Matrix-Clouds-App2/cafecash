import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../app/router/navigation_services.dart';
import '../../app/router/routes.dart';
import '../extensions/extensions.dart';
import '../utils/app_colors.dart';
import '../utils/app_images.dart';
import '../utils/locale_keys.dart';
import 'app_button.dart';
import 'app_text.dart';

class GuestLockView extends StatelessWidget {
  const GuestLockView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: 24.paddingAll,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(AppImages.visitor, width: 200.w, fit: BoxFit.contain),
            20.height,
            AppText(
              LocaleKeys.guest_lockTitle.tr(),
              fontSize: 19,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimaryColor.themeColor,
              textAlign: TextAlign.center,
            ),
            10.height,
            AppText(
              LocaleKeys.guest_lockMessage.tr(),
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondaryColor.themeColor,
              textAlign: TextAlign.center,
            ),
            28.height,
            CustomButton(
              title: LocaleKeys.profile_loginNow.tr(),
              color: AppColors.primaryColor.themeColor,
              borderColor: AppColors.primaryColor.themeColor,
              textColor: Colors.white,
              onTap: () => NavigationService.push(Routes.loginScreen),
            ),
          ],
        ),
      ),
    );
  }
}
