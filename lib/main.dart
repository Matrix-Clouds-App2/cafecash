import 'package:easy_localization/easy_localization.dart' as tr;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get_storage/get_storage.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tzz;

import 'app/app.dart';
import 'core/di/injection.dart';
import 'core/notifications/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  final tzInfo = await FlutterTimezone.getLocalTimezone();
  tzz.setLocalLocation(tzz.getLocation(tzInfo.identifier));
  await GetStorage.init();
  await tr.EasyLocalization.ensureInitialized();
  // await Firebase.initializeApp();
  // FirebaseMessaging.onBackgroundMessage(firebaseBackgroundMessageHandler);
  // await NotificationService.init();
  await setupDi();

  runApp(
    tr.EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      startLocale: const Locale('ar'),
      child: SafeArea(
          top: false,
          child: const MyApp()),
    ),
  );
}
DateTime date = DateTime(2026, 5, 14);
bool isAfterTwoDaysResult = isAfterTwoDays(date);
bool isAfterTwoDays(DateTime givenDate) {
  DateTime currentDate = DateTime.now();
  DateTime targetDate = givenDate.add(const Duration(days: 2));
  return currentDate.isAfter(targetDate);
}
