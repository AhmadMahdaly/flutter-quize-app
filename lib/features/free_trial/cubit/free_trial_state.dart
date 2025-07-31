part of 'free_trial_cubit.dart';

enum FetchStatus { initial, loading, success, failure }

class TrialExamState extends Equatable {
  const TrialExamState({
    this.status = FetchStatus.initial,
    this.questions = const [],
    this.currentQuestionIndex = 0,
    this.errorMessage,
    this.userAnswers = const {},
  });
  final FetchStatus status;
  final List<TrialQuestion> questions;
  final int currentQuestionIndex;
  final String? errorMessage;
  final Map<int, String> userAnswers;

  TrialExamState copyWith({
    FetchStatus? status,
    List<TrialQuestion>? questions,
    int? currentQuestionIndex,
    String? errorMessage,
    Map<int, String>? userAnswers,
  }) {
    return TrialExamState(
      status: status ?? this.status,
      questions: questions ?? this.questions,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      errorMessage: errorMessage ?? this.errorMessage,
      userAnswers: userAnswers ?? this.userAnswers,
    );
  }

  @override
  List<Object?> get props => [
    status,
    questions,
    currentQuestionIndex,
    errorMessage,
    userAnswers,
  ];
}
