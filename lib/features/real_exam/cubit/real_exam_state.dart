part of 'real_exam_cubit.dart';

class RealExamState {
  final int? currentIndex;

  RealExamState({
    this.currentIndex,
  });

  RealExamState copyWith({
    int? currentIndex,
  }) {
    return RealExamState(
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }
}

class RealExamInitialState extends RealExamState {}

/// start real exam
class StartRealExamLoadingState extends RealExamState {}

class StartRealExamSuccessState extends RealExamState {}

class StartRealExamFailedState extends RealExamState {}

/// get question
class GetQuestionLoadingState extends RealExamState {}

class GetQuestionSuccessState extends RealExamState {}

class GetQuestionFailedState extends RealExamState {}

/// get real exam question
class GetRealExamQLoadingState extends RealExamState {}

class GetRealExamQSuccessState extends RealExamState {}

class GetRealExamQFailedState extends RealExamState {}

/// answer quesion
class AnswerQLoadingState extends RealExamState {}

class AnswerQSuccessState extends RealExamState {}

class AnswerQFailedState extends RealExamState {}

/// make flag
class MakeFlagLoadingState extends RealExamState {}

class MakeFlagSuccessState extends RealExamState {}

class MakeFlagFailedState extends RealExamState {}

/// add note
class AddNoteLoadingState extends RealExamState {}

class AddNoteSuccessState extends RealExamState {}

class AddNoteFailedState extends RealExamState {}

/// finish analysis exam
class FinishAnalysisExamLoadingState extends RealExamState {}

class FinishAnalysisExamSuccessState extends RealExamState {}

class FinishAnalysisExamFailedState extends RealExamState {}

/// exam history
class ExamHistoryLoadingState extends RealExamState {}

class ExamHistorySuccessState extends RealExamState {}

class ExamHistoryFailedState extends RealExamState {}