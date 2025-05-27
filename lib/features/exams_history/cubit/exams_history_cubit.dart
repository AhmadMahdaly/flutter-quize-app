import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'exams_history_state.dart';

class ExamsHistoryCubit extends Cubit<ExamsHistoryStates> {
  ExamsHistoryCubit() : super( ExamsHistoryInitialState());


}