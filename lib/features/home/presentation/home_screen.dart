import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/app_text.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AppText(LocaleKeys.home_welcome.tr(), fontSize: 18),
      ),
    );
  }
}
