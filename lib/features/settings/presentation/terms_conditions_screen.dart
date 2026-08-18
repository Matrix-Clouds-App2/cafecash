import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../core/extensions/extensions.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/locale_keys.dart';
import 'widgets/content_section.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;

    return Scaffold(
      backgroundColor: AppColors.surfaceColor.themeColor,
      appBar: AppBar(
        title: Text(LocaleKeys.settings_termsConditions.tr()),
        backgroundColor: primary,
        foregroundColor: AppColors.textPrimaryColor.themeColor,
      ),
      body: SingleChildScrollView(
        padding: 16.paddingAll,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ContentSection(
              title: LocaleKeys.settings_termsSection1Title.tr(),
              body: LocaleKeys.settings_termsSection1Body.tr(),
            ),
            ContentSection(
              title: LocaleKeys.settings_termsSection2Title.tr(),
              body: LocaleKeys.settings_termsSection2Body.tr(),
            ),
            ContentSection(
              title: LocaleKeys.settings_termsSection3Title.tr(),
              body: LocaleKeys.settings_termsSection3Body.tr(),
            ),
            ContentSection(
              title: LocaleKeys.settings_termsSection4Title.tr(),
              body: LocaleKeys.settings_termsSection4Body.tr(),
            ),
            ContentSection(
              title: LocaleKeys.settings_termsSection5Title.tr(),
              body: LocaleKeys.settings_termsSection5Body.tr(),
            ),
          ],
        ),
      ),
    );
  }
}
