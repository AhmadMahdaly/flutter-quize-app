part of 'real_exam_cubit.dart';

class RealExamState {
  RealExamState({
    this.currentIndex,
  });
  final int? currentIndex;

  RealExamState copyWith({
    int? currentIndex,
  }) {
    return RealExamState(
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }
}

class RealExamInitialState extends RealExamState {}

class StartRealExamLoadingState extends RealExamState {}

class GetQuestionLoadingState extends RealExamState {
  GetQuestionLoadingState(this.examModel,);
  final StartRealExamModel examModel;

}

class StartRealExamSuccessState extends RealExamState {
  StartRealExamSuccessState(this.examModel, );
  final StartRealExamModel examModel;
}

class StartRealExamFailedState extends RealExamState {
  StartRealExamFailedState(this.message);
  final String message;
}

class GetQuestionFailedState extends RealExamState {
  GetQuestionFailedState(this.message);
  final String message;
}

class GetQuestionSuccessState extends RealExamState {}

class GetRealExamQLoadingState extends RealExamState {}

class GetRealExamQSuccessState extends RealExamState {}

class GetRealExamQFailedState extends RealExamState {}

class AnswerQLoadingState extends RealExamState {}

class AnswerQSuccessState extends RealExamState {}

class AnswerQFailedState extends RealExamState {}

class MakeFlagLoadingState extends RealExamState {}

class MakeFlagSuccessState extends RealExamState {}

class MakeFlagFailedState extends RealExamState {}

class AddNoteLoadingState extends RealExamState {}

class AddNoteSuccessState extends RealExamState {}

class AddNoteFailedState extends RealExamState {}

class FinishAnalysisExamLoadingState extends RealExamState {}

class FinishAnalysisExamSuccessState extends RealExamState {}

class FinishAnalysisExamFailedState extends RealExamState {}

class ExamHistoryLoadingState extends RealExamState {}

class ExamHistorySuccessState extends RealExamState {}

class ExamHistoryFailedState extends RealExamState {}
