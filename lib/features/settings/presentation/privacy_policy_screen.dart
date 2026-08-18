import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../core/extensions/extensions.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/locale_keys.dart';
import 'widgets/content_section.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;

    return Scaffold(
      backgroundColor: AppColors.surfaceColor.themeColor,
      appBar: AppBar(
        title: Text(LocaleKeys.settings_privacyPolicy.tr()),
        backgroundColor: primary,
        foregroundColor: AppColors.textPrimaryColor.themeColor,
      ),
      body: SingleChildScrollView(
        padding: 16.paddingAll,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ContentSection(
              title: LocaleKeys.settings_privacySection1Title.tr(),
              body: LocaleKeys.settings_privacySection1Body.tr(),
            ),
            ContentSection(
              title: LocaleKeys.settings_privacySection2Title.tr(),
              body: LocaleKeys.settings_privacySection2Body.tr(),
            ),
            ContentSection(
              title: LocaleKeys.settings_privacySection3Title.tr(),
              body: LocaleKeys.settings_privacySection3Body.tr(),
            ),
            ContentSection(
              title: LocaleKeys.settings_privacySection4Title.tr(),
              body: LocaleKeys.settings_privacySection4Body.tr(),
            ),
            ContentSection(
              title: LocaleKeys.settings_privacySection5Title.tr(),
              body: LocaleKeys.settings_privacySection5Body.tr(),
            ),
          ],
        ),
      ),
    );
  }
}
