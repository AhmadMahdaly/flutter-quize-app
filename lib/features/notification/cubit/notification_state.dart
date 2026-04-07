part of 'notification_cubit.dart';

@immutable
abstract class NotificationState {}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationSuccess extends NotificationState {
  NotificationSuccess(this.notifications);
  final List<NotificationModel> notifications;
}

class NotificationError extends NotificationState {
  NotificationError(this.errorMessage);
  final String errorMessage;
}
