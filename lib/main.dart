import 'package:easy_localization/easy_localization.dart' as tr;
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import 'app/app.dart';
import 'core/di/injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await tr.EasyLocalization.ensureInitialized();
  await setupDi();

  runApp(
    tr.EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      startLocale: const Locale('ar'),
      child: const SafeArea(top: false, child: MyApp()),
    ),
  );
}
