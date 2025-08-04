part of 'exams_history_cubit.dart';

@immutable
abstract class ExamsHistoryState {}

class ExamsHistoryInitial extends ExamsHistoryState {}

class ExamsHistoryLoading extends ExamsHistoryState {}

class ExamsHistorySuccess extends ExamsHistoryState {}

class ExamsHistoryFailure extends ExamsHistoryState {
  ExamsHistoryFailure(this.errorMessage);
  final String errorMessage;
}
