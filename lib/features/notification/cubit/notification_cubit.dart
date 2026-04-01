import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smle/features/notification/data/models/notification_model.dart';
import 'package:smle/features/notification/data/repo/notification_repo.dart';
part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit(this.notificationRepo) : super(NotificationInitial());
  final NotificationRepo notificationRepo;

  // إرسال التوكن للباك اند
  Future<void> updateFcmToken(String token) async {
    try {
      await notificationRepo.sendFcmToken(token);
      debugPrint('FCM Token Updated Successfully');
    } catch (e) {
      debugPrint('Failed to update FCM Token: $e');
    }
  }

  // Future<void> fetchNotifications() async {
  //   emit(NotificationLoading());
  //   try {
  //     final notifications = await notificationRepo
  //         .getNotifications(); // تأكد من تفعيلها في الـ Repo
  //     emit(NotificationSuccess(notifications));
  //   } catch (e) {
  //     emit(NotificationError(e.toString()));
  //   }
  // }
}
