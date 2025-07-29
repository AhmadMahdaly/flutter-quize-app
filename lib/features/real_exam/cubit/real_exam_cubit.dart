import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smle/core/helpers/loading.dart';
import 'package:smle/features/real_exam/data/model/finish_analysis_exam.dart';
import 'package:smle/features/real_exam/data/model/get_real_exam_model.dart';
import 'package:smle/features/real_exam/data/model/question_action_model.dart';
import 'package:smle/features/real_exam/data/repo/real_exam_repo.dart';

part 'real_exam_state.dart';

class RealExamCubit extends Cubit<RealExamState> {
  RealExamCubit(this.repo) : super(RealExamInitialState());
  final RealExamRepo repo;
  final Map<int, bool> _questionBookmarkedStatus = {};

  Future<void> startRealExam() async {
    emit(StartRealExamLoadingState());
    showLoading();
    final result = await repo.startRealExam();
    hideLoading();
    if (isClosed) return;
    result.when(
      success: (successData) {
        _updateBookmarkStatus(successData.data);
        emit(
          StartRealExamSuccessState(
            successData,
            Map.from(_questionBookmarkedStatus),
          ),
        );
      },
      failure: (error) {
        emit(StartRealExamFailedState(error.errMessage));
      },
    );
  }

  Future<void> getQuestion(int examId, int qNo, int section) async {
    if (state is! StartRealExamSuccessState) return;

    final previousState = state as StartRealExamSuccessState;
    final totalQuestions = previousState.examModel.questionsCount;
    final preservedExamId = previousState.examModel.examId;
    showLoading();
    // emit(GetQuestionLoadingState());

    final result = await repo.getQuestion(examId, qNo, section);
    if (isClosed) return;

    result.when(
      success: (newQuestionModel) {
        _updateBookmarkStatus(newQuestionModel.data);
        final mergedModel = StartRealExamModel(
          status: newQuestionModel.status,
          message: newQuestionModel.message,
          examId: preservedExamId,
          questionsCount: totalQuestions,
          data: newQuestionModel.data,
        );
        hideLoading();
        emit(
          StartRealExamSuccessState(
            mergedModel,
            Map.from(_questionBookmarkedStatus),
          ),
        );
      },
      failure: (error) {
        emit(StartRealExamFailedState(error.errMessage));
      },
    );
  }

  void _updateBookmarkStatus(Question? question) {
    if (question != null &&
        question.questionNo != null &&
        question.isBookmarked != null) {
      _questionBookmarkedStatus[question.questionNo!] = question.isBookmarked!;
    }
  }

  void goToNext() {
    if (state is StartRealExamSuccessState) {
      final currentState = state as StartRealExamSuccessState;
      final examModel = currentState.examModel;

      if (examModel.data?.questionNo != null &&
          examModel.questionsCount != null) {
        final currentQuestionNo = examModel.data!.questionNo!;
        final totalQuestions = examModel.questionsCount!;
        if (currentQuestionNo < totalQuestions) {
          getQuestion(
            examModel.examId!,
            currentQuestionNo + 1,
            examModel.data!.section!,
          );
        }
      }
    }
  }

  void goToPrevious() {
    if (state is StartRealExamSuccessState) {
      final currentState = state as StartRealExamSuccessState;
      final examModel = currentState.examModel;
      if (examModel.data?.questionNo != null &&
          examModel.data!.questionNo! > 1) {
        getQuestion(
          examModel.examId!,
          examModel.data!.questionNo! - 1,
          examModel.data!.section!,
        );
      }
    }
  }

  void goToIndex(int qNo) {
    if (state is StartRealExamSuccessState) {
      final currentState = state as StartRealExamSuccessState;
      final examModel = currentState.examModel;
      getQuestion(examModel.examId!, qNo, examModel.data!.section!);
    }
  }

  QuestionActionModel? questionActionModel;
  Future answerQuestion(String questionId, String answer) async {
    // showLoading();
    // emit(AnswerQLoadingState());
    final result = await repo.answerQuestion(questionId, answer);
    result.when(
      success: (success) {
        questionActionModel = success;
        // hideLoading();
        // emit(AnswerQSuccessState());
      },
      failure: (error) {
        // hideLoading();
        // emit(AnswerQFailedState());
      },
    );
  }

  // Future makeQuestionFlag(String questionId) async {
  //   // showLoading();
  //   // emit(MakeFlagLoadingState());
  //   final result = await repo.makeQuestionFlag(questionId);
  //   result.when(success: (success) {
  //     questionActionModel = success;
  //     // hideLoading();
  //     // emit(MakeFlagSuccessState());
  //   }, failure: (error) {
  //     // hideLoading();
  //     // emit(MakeFlagFailedState());
  //   });
  // }
  Future<void> makeQuestionFlag() async {
    if (state is! StartRealExamSuccessState) return;

    final currentState = state as StartRealExamSuccessState;
    final examModel = currentState.examModel;
    final questionNo = examModel.data!.questionNo!;
    final questionId = examModel.data!.id.toString();

    // 1. تحديث الواجهة فورًا (Optimistic UI)
    final newBookmarkStatus = !(_questionBookmarkedStatus[questionNo] ?? false);
    _questionBookmarkedStatus[questionNo] = newBookmarkStatus;

    final updatedQuestion = examModel.data!.copyWith(
      isBookmarked: newBookmarkStatus,
    );
    final updatedExamModel = examModel.copyWith(data: updatedQuestion);

    emit(
      StartRealExamSuccessState(
        updatedExamModel,
        Map.from(_questionBookmarkedStatus),
      ),
    );

    // 2. استدعاء الخادم في الخلفية
    await repo.makeQuestionFlag(questionId);
  }

  Future addQuestionNote(String questionId, String note) async {
    showLoading();
    emit(AddNoteLoadingState());
    final result = await repo.addQuestionNote(questionId, note);
    result.when(
      success: (success) {
        questionActionModel = success;
        hideLoading();
        emit(AddNoteSuccessState());
      },
      failure: (error) {
        hideLoading();
        emit(AddNoteFailedState());
      },
    );
  }

  FinishAnalysisExamModel? finishAnalysisExamModel;
  Future finishAnalysisExam() async {
    showLoading();
    emit(FinishAnalysisExamLoadingState());
    final result = await repo.finishAnalysisExam();
    result.when(
      success: (success) {
        finishAnalysisExamModel = success;
        hideLoading();
        emit(FinishAnalysisExamSuccessState());
      },
      failure: (error) {
        hideLoading();
        emit(FinishAnalysisExamFailedState());
      },
    );
  }

  Future examHistory(int offset, int limit) async {
    showLoading();
    emit(ExamHistoryLoadingState());
    final result = await repo.examHistory(offset, limit);
    result.when(
      success: (success) {
        finishAnalysisExamModel = success;
        hideLoading();
        emit(ExamHistorySuccessState());
      },
      failure: (error) {
        hideLoading();
        emit(ExamHistoryFailedState());
      },
    );
  }
}
