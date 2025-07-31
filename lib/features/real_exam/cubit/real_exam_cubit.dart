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
  final Map<int, bool> _questionNoteStatus = {};
  Future<void> startRealExam() async {
    emit(StartRealExamLoadingState());
    showLoading();
    final result = await repo.startRealExam();
    hideLoading();
    if (isClosed) return;
    result.when(
      success: (successData) {
        _updateStatuses(successData.data);
        emit(
          StartRealExamSuccessState(
            successData,
            Map.from(_questionBookmarkedStatus),
            Map.from(_questionNoteStatus),
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
        _updateStatuses(newQuestionModel.data);
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
            Map.from(_questionNoteStatus),
          ),
        );
      },
      failure: (error) {
        emit(StartRealExamFailedState(error.errMessage));
      },
    );
  }

  void _updateStatuses(Question? question) {
    if (question == null || question.questionNo == null) return;

    // تحديث البوكمارك
    if (question.isBookmarked != null) {
      _questionBookmarkedStatus[question.questionNo!] = question.isBookmarked!;
    }
    // تحديث الملاحظات
    _questionNoteStatus[question.questionNo!] =
        (question.notes ?? '').isNotEmpty;
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

  Future<void> makeQuestionFlag() async {
    if (state is! StartRealExamSuccessState) return;

    final currentState = state as StartRealExamSuccessState;
    final examModel = currentState.examModel;
    final questionNo = examModel.data!.questionNo!;
    final questionId = examModel.data!.id.toString();

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
        Map.from(_questionNoteStatus),
      ),
    );

    await repo.makeQuestionFlag(questionId);
  }

  Future<void> addQuestionNote(String note) async {
    if (state is! StartRealExamSuccessState) return;

    final currentState = state as StartRealExamSuccessState;
    final examModel = currentState.examModel;
    final questionNo = examModel.data!.questionNo!;
    final questionId = examModel.data!.id.toString();

    _questionNoteStatus[questionNo] = note.isNotEmpty;

    final updatedQuestion = examModel.data!.copyWith(notes: note);
    final updatedExamModel = examModel.copyWith(data: updatedQuestion);

    emit(
      StartRealExamSuccessState(
        updatedExamModel,
        Map.from(_questionBookmarkedStatus),
        Map.from(_questionNoteStatus),
      ),
    );

    await repo.addQuestionNote(questionId, note);
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
}
