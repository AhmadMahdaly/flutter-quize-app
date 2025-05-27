import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:smle/core/cache_helper/cache_helper.dart';
import 'package:smle/core/cache_helper/cache_values.dart';
import 'package:smle/core/constants.dart';
import 'package:smle/core/shared_widgets/debug_print_widget.dart';
import 'package:smle/core/shared_widgets/notifcation_snack_bar.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  debugPrintWidget("${message.data}");
}

class PushNotificationService {
  final _fcm = FirebaseMessaging.instance;
  String? fCMToken;
  final _localNotifications = FlutterLocalNotificationsPlugin();
  void handleMessage(RemoteMessage? message) {
    if (message == null) {
      return;
    } else {

    }
  }

  Future initLocalNotifications() async {
    const android = AndroidInitializationSettings('@drawable/ic_launcher');
    const settings = InitializationSettings(android: android);

    await _localNotifications.initialize(
      settings,
    );
  }

  Future initPushNotifications() async {
    await _fcm.requestPermission();
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onMessage.listen((event) {
      final notification = event.notification;
      if (notification == null) return;
      notificationSnackBar(
          context: navigatorKey.currentContext,
          message: notification.title,
          event: event);
    });
  }

  Future<void> initialize() async {
    if (Platform.isAndroid) {
      _localNotifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()!
          .requestNotificationsPermission();
    }
    if (Platform.isIOS) {
      _localNotifications
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()!
          .requestPermissions(
            alert: true,
            badge: true,
            provisional: false,
            sound: true,
          )
          .then((value) async {
        await FirebaseMessaging.instance
            .setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );
      });
    }
    await _fcm.requestPermission();
    await _fcm.getAPNSToken();
    await Future.delayed(const Duration(seconds: 2));
    fCMToken = await _fcm.getToken();
    await CacheHelper.saveData(key: CacheKeys.deviceToken, value: fCMToken);
    await initPushNotifications();
  }
}
