import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../core/extensions/extensions.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/locale_keys.dart';
import 'widgets/profile_card.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

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
            const ProfileCard(),
            24.height,
          ],
        ),
      ),
    );
  }
}
