import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


// ── Background handler ────────────────────────────────────────────────────────
// Must be a top-level function — Firebase runs it in a separate isolate.
@pragma('vm:entry-point')
Future<void> firebaseBackgroundMessageHandler(RemoteMessage message) async {
  _printNotificationTitleAndBody('background', message);
  _logRemoteMessage('background', message);
  // Nothing to do here for display; FCM shows the notification automatically
  // when the app is in background/terminated and the payload contains a
  // "notification" block. Data-only messages can be processed here.
}

void _printNotificationTitleAndBody(String source, RemoteMessage message) {
  final notification = message.notification;
  print('[NotificationService][$source] title: ${notification?.title ?? ''}');
  print('[NotificationService][$source] body: ${notification?.body ?? ''}');
}

void _logRemoteMessage(String source, RemoteMessage message) {
  final notification = message.notification;
  final payload = <String, dynamic>{
    'source': source,
    'messageId': message.messageId,
    'from': message.from,
    'category': message.category,
    'collapseKey': message.collapseKey,
    'contentAvailable': message.contentAvailable,
    'mutableContent': message.mutableContent,
    'sentTime': message.sentTime?.toIso8601String(),
    'ttl': message.ttl,
    'title': notification?.title,
    'body': notification?.body,
    'titleLocKey': notification?.titleLocKey,
    'bodyLocKey': notification?.bodyLocKey,
    'data': message.data,
  };

  const encoder = JsonEncoder.withIndent('  ');
  print('[NotificationService] Incoming notification:\n${encoder.convert(payload)}');
}

// ── Notification channel config ───────────────────────────────────────────────
const _channelId = 'wuf13_main_v2';
const _channelName = 'WUF 13';
const _channelDesc = 'إشعارات تطبيق منتدى WUF 13';

class NotificationService {
  NotificationService._();

  static final _plugin = FlutterLocalNotificationsPlugin();

  // ── Public API ──────────────────────────────────────────────────────────────

  static Future<void> init() async {
    if (Platform.isIOS) {
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
    await _requestPermissions();
    await _initPlugin();
    await _createAndroidChannel();
    _listenForeground();
    _listenTap();
    await _checkInitialMessage();
  }

  static const _batteryChannel = MethodChannel('com.app.wuf13/battery');

  /// Returns true if exact-alarm scheduling is already permitted.
  static Future<bool> isExactAlarmGranted() async {
    if (!Platform.isAndroid) return true;
    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    return await androidPlugin?.canScheduleExactNotifications() ?? true;
  }

  /// Returns true if the app is already exempt from battery optimization.
  static Future<bool> isBatteryExempt() async {
    if (!Platform.isAndroid) return true;
    try {
      return await _batteryChannel
              .invokeMethod<bool>('isIgnoringBatteryOptimizations') ??
          true;
    } catch (_) {
      return true;
    }
  }

  /// Opens "Alarms & Reminders" settings if exact-alarm permission is not granted.
  static Future<void> requestExactAlarmIfNeeded() async {
    if (!Platform.isAndroid) return;
    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin == null) return;
    final granted = await androidPlugin.canScheduleExactNotifications() ?? true;
    if (!granted) await androidPlugin.requestExactAlarmsPermission();
  }

  /// Opens battery optimization exemption dialog if not already exempt.
  /// On Realme/OPPO/Xiaomi this is required for AlarmManager to fire when closed.
  static Future<void> requestBatteryOptimizationIfNeeded() async {
    if (!Platform.isAndroid) return;
    try {
      final ignoring = await _batteryChannel
              .invokeMethod<bool>('isIgnoringBatteryOptimizations') ??
          true;
      if (!ignoring) {
        await _batteryChannel
            .invokeMethod('requestIgnoreBatteryOptimizations');
      }
    } catch (_) {}
  }

  // ── Permissions ─────────────────────────────────────────────────────────────

  static Future<void> _requestPermissions() async {
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      announcement: false,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
    );

    if (Platform.isAndroid) {
      await _plugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    }
  }

  // ── Local notifications init ─────────────────────────────────────────────────

  static Future<void> _initPlugin() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/launcher_icon');

    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(
      settings,
      onDidReceiveNotificationResponse: _onLocalTap,
    );
  }

  // ── Android notification channel ─────────────────────────────────────────────

  static Future<void> _createAndroidChannel() async {
    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    const channel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: _channelDesc,
      importance: Importance.high,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('notification'),
      enableVibration: true,
      showBadge: true,
    );
    await androidPlugin?.createNotificationChannel(channel);
  }

  // ── Foreground message listener ──────────────────────────────────────────────

  static void _listenForeground() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _printNotificationTitleAndBody('foreground', message);
      _logRemoteMessage('foreground', message);

      // iOS: setForegroundNotificationPresentationOptions handles display natively.
      if (Platform.isIOS) return;

      final notification = message.notification;
      if (notification == null) return;

      _plugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        _buildNotificationDetails(),
        payload: message.data['route'] as String?,
      );
    });
  }

  static NotificationDetails _buildNotificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDesc,
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/launcher_icon',
        playSound: true,
        sound: RawResourceAndroidNotificationSound('notification'),
        enableVibration: true,
        showWhen: true,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        sound: 'notification.mp3',
      ),
    );
  }

  // ── Tap handling ─────────────────────────────────────────────────────────────

  // App was in background and user tapped the FCM notification.
  static void _listenTap() {
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _logRemoteMessage('opened_app', message);
      _handleRemoteMessage(message);
    });
  }

  // App was fully terminated and user tapped the notification that opened it.
  static Future<void> _checkInitialMessage() async {
    try {
      final initial = await FirebaseMessaging.instance
          .getInitialMessage()
          .timeout(const Duration(seconds: 5));
      if (initial != null) {
        _logRemoteMessage('initial_message', initial);
        _handleRemoteMessage(initial);
      }
    } catch (_) {
      // Timeout or platform error — safe to ignore, no initial message to handle.
    }
  }

  // App was in foreground and user tapped the local notification.
  static void _onLocalTap(NotificationResponse response) {
    // TODO: navigate based on response.payload if needed
  }

  static void _handleRemoteMessage(RemoteMessage message) {
    // TODO: navigate based on message.data['route'] if needed
  }
}
