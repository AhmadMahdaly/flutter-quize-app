import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smle/core/fcm.dart';
import 'package:smle/core/shared_widgets/debug_print_widget.dart';
import 'package:smle/features/notification/cubit/notification_cubit.dart';

class NotificationPermissionDialog {
  static Future<void> showIfNeeded(BuildContext context) async {
    final NotificationSettings settings = await FirebaseMessaging.instance
        .getNotificationSettings();

    if (settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional) {
      final token = await FCMService.instance.getToken();
      if (token != null && context.mounted) {
        context.read<NotificationCubit>().updateFcmToken(token);
        debugPrintWidget('Permission already granted, token sent to server.');
      }
    } else {
      if (context.mounted) {
        _showPermissionDialog(context);
      }
    }
  }

  static Future<void> _showPermissionDialog(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Enable Notifications'),
        content: const Text(
          'We need to enable notifications to inform you about request statuses, attendance, and approvals.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Later'),
          ),
          ElevatedButton(
            // داخل ملف الـ Dialog
            onPressed: () async {
              Navigator.pop(dialogContext);

              // 1. طلب الصلاحية
              final allowed = await FCMService.instance.requestPermission();

              if (allowed) {
                final token = await FCMService.instance.getToken();

                if (token != null && context.mounted) {
                  context.read<NotificationCubit>().updateFcmToken(token);
                } else {
                  debugPrintWidget(
                    'Token is still null, maybe APNS delay on iOS',
                  );
                }
              }
            },
            child: const Text('Enable Now'),
          ),
        ],
      ),
    );
  }
}
