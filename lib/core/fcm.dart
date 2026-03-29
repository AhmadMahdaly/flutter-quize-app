import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:smle/core/cache_helper/cache_helper.dart';
import 'package:smle/core/cache_helper/cache_values.dart';
import 'package:smle/core/shared_widgets/debug_print_widget.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrintWidget('Background message received: ${message.data}');
}

class FCMService {
  FCMService._();
  static final instance = FCMService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  // ================= INIT =================

  Future<void> initialize() async {
    if (_isInitialized) return;
    _isInitialized = true;

    /// 🔔 ANDROID CHANNEL (REQUIRED)
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'hr_alsaif_channel',
      'General Notifications',
      description: 'General notifications for HR Alsaif app',
      importance: Importance.max,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);

    /// 🔔 LOCAL NOTIFICATION INIT
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/launcher_icon',
    );

    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (details) {
        debugPrintWidget(
          'Notification clicked (foreground): ${details.payload}',
        );
      },
    );

    /// 🔥 FCM BACKGROUND HANDLER
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    /// 🔔 iOS FOREGROUND OPTIONS
    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    /// 📩 FOREGROUND MESSAGE
    FirebaseMessaging.onMessage.listen((message) {
      debugPrintWidget('Foreground message: ${message.data}');
      showNotification(message);
    });

    /// 📩 CLICKED NOTIFICATION
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      debugPrintWidget('Notification opened: ${message.data}');
    });

    /// 🔄 TOKEN REFRESH
    _listenToTokenRefresh();

    await _messaging.setAutoInitEnabled(true);
  }

  // ================= PERMISSION =================

  Future<bool> requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (Platform.isAndroid) {
      await _localNotifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestNotificationsPermission();
    }

    return settings.authorizationStatus == AuthorizationStatus.authorized;
  }

  // ================= TOKEN =================

  Future<String?> getToken() async {
    try {
      final token = await _messaging.getToken();
      if (token != null) {
        await _updateTokenOnServer(token);
      }
      debugPrintWidget('FCM Token: $token');
      return token;
    } catch (e) {
      debugPrintWidget('Token error: $e');
      return null;
    }
  }

  void _listenToTokenRefresh() {
    _messaging.onTokenRefresh.listen((newToken) async {
      debugPrintWidget('Token refreshed: $newToken');
      await _updateTokenOnServer(newToken);
    });
  }

  Future<void> _updateTokenOnServer(String token) async {
    await CacheHelper.saveData(key: CacheKeys.deviceToken, value: token);

    // Repository.sendToken(token);
    debugPrintWidget('Token saved locally');
  }

  // ================= SHOW NOTIFICATION =================

  Future<void> showNotification(RemoteMessage message) async {
    final title =
        message.notification?.title ?? message.data['title'] ?? 'Notification';

    final body = message.notification?.body ?? message.data['body'] ?? '';

    const androidDetails = AndroidNotificationDetails(
      'hr_alsaif_channel',
      'General Notifications',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: title,
      body: body,
      notificationDetails: notificationDetails,
      payload: message.data.toString(),
    );
  }
}
