import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../core/extensions/extensions.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/locale_keys.dart';
import 'widgets/content_section.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;

    return Scaffold(
      backgroundColor: AppColors.surfaceColor.themeColor,
      appBar: AppBar(
        title: Text(LocaleKeys.settings_aboutUs.tr()),
        backgroundColor: primary,
        foregroundColor: AppColors.textPrimaryColor.themeColor,
      ),
      body: SingleChildScrollView(
        padding: 16.paddingAll,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ContentSection(
              title: LocaleKeys.settings_aboutSection1Title.tr(),
              body: LocaleKeys.settings_aboutSection1Body.tr(),
            ),
            ContentSection(
              title: LocaleKeys.settings_aboutSection2Title.tr(),
              body: LocaleKeys.settings_aboutSection2Body.tr(),
            ),
            ContentSection(
              title: LocaleKeys.settings_aboutSection3Title.tr(),
              body: LocaleKeys.settings_aboutSection3Body.tr(),
            ),
            // ContentSection(
            //   title: LocaleKeys.settings_aboutSection4Title.tr(),
            //   body: LocaleKeys.settings_aboutSection4Body.tr(),
            // ),
          ],
        ),
      ),
    );
  }
}
