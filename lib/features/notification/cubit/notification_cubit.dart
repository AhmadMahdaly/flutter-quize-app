import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationStates> {
  NotificationCubit() : super( NotificationInitialState());


}