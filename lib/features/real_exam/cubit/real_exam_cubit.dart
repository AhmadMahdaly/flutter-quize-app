import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:smle/core/di.dart';
import 'package:smle/core/helpers/loading.dart';
import 'package:smle/features/main%20layout/cubit/main_layout_cubit.dart';
import 'package:smle/features/real_exam/data/model/finish_analysis_exam.dart';
import 'package:smle/features/real_exam/data/model/get_real_exam_model.dart';
import 'package:smle/features/real_exam/data/model/question_action_model.dart';
import 'package:smle/features/real_exam/data/repo/real_exam_repo.dart';

part 'real_exam_state.dart';

class RealExamCubit extends HydratedCubit<RealExamState> {
  RealExamCubit(this.repo) : super(const RealExamState());
  final RealExamRepo repo;

  @override
  RealExamState? fromJson(Map<String, dynamic> json) =>
      RealExamState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(RealExamState state) => state.toJson();

  Future<void> startOrResumeExam() async {
    if (state.status == ExamStatus.success && state.examModel != null ||
        state.status == ExamStatus.onBreak) {
      return;
    }
    showLoading();
    emit(state.copyWith(status: ExamStatus.loading));
    getIt<MainLayoutCubit>().getProfile();
    final result = await repo.startRealExam();
    hideLoading();
    if (isClosed) return;
    result.when(
      success: (successData) {
        final newBookmarks = <int, bool>{};
        final newNotes = <int, bool>{};
        final newAnswers = <int, String>{};
        _updateStatuses(successData.data, newBookmarks, newNotes, newAnswers);
        final newEndTimes = Map<int, String>.from(state.sectionEndTimes);

        if (!newEndTimes.containsKey(1)) {
          final endTime = DateTime.now().add(const Duration(minutes: 120));
          newEndTimes[1] = endTime.toIso8601String();
        }

        emit(
          state.copyWith(
            status: ExamStatus.success,
            examModel: successData,
            sectionEndTimes: newEndTimes,
            bookmarkedStatuses: newBookmarks,
            noteStatuses: newNotes,
            answersStatus: newAnswers,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            status: ExamStatus.error,
            errorMessage: error.errMessage,
          ),
        );
      },
    );
  }

  Future<void> getQuestion(int examId, int qNo, int section) async {
    if (isClosed) return;
    showLoading();

    final result = await repo.getQuestion(examId, qNo, section);
    hideLoading();
    if (isClosed) return;

    result.when(
      success: (newQuestionModel) {
        final currentBookmarks = Map<int, bool>.from(state.bookmarkedStatuses);
        final currentNotes = Map<int, bool>.from(state.noteStatuses);
        final currentAnswers = Map<int, String>.from(state.answersStatus);
        _updateStatuses(
          newQuestionModel.data,
          currentBookmarks,
          currentNotes,
          currentAnswers,
        );

        final mergedModel = StartRealExamModel(
          status: newQuestionModel.status,
          message: newQuestionModel.message,
          examId: state.examModel!.examId,
          questionsCount: state.examModel!.questionsCount,
          data: newQuestionModel.data,
        );
        emit(
          state.copyWith(
            status: ExamStatus.success,
            examModel: mergedModel,
            bookmarkedStatuses: currentBookmarks,
            noteStatuses: currentNotes,
            answersStatus: currentAnswers,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            status: ExamStatus.error,
            errorMessage: error.errMessage,
          ),
        );
      },
    );
  }

  void _updateStatuses(
    Question? question,
    Map<int, bool> bookmarks,
    Map<int, bool> notes,
    Map<int, String> answers,
  ) {
    if (question == null || question.questionNo == null) return;
    if (question.isBookmarked != null) {
      bookmarks[question.questionNo!] = question.isBookmarked!;
    }
    notes[question.questionNo!] = (question.notes ?? '').isNotEmpty;
    if (question.userAnswer != null && question.userAnswer!.isNotEmpty) {
      answers[question.questionNo!] = question.userAnswer!;
    }
  }

  void goToNext() async {
    // await Future.delayed(const Duration(milliseconds: 300));
    if (state.examModel?.data?.questionNo != null) {
      final currentQuestionNo = state.examModel!.data!.questionNo!;
      final totalQuestions = state.examModel!.questionsCount!;
      if (currentQuestionNo < totalQuestions) {
        getQuestion(
          state.examModel!.examId!,
          currentQuestionNo + 1,
          state.examModel!.data!.section!,
        );
      }
    }
  }

  void goToPrevious() {
    if (state.examModel?.data?.questionNo != null &&
        state.examModel!.data!.questionNo! > 1) {
      getQuestion(
        state.examModel!.examId!,
        state.examModel!.data!.questionNo! - 1,
        state.examModel!.data!.section!,
      );
    }
  }

  void goToIndex(int qNo) {
    if (state.examModel != null) {
      getQuestion(
        state.examModel!.examId!,
        qNo,
        state.examModel!.data!.section!,
      );
    }
  }

  void finishSection1AndStartBreak() {
    if (isClosed) return;
    showLoading();
    emit(
      state.copyWith(
        status: ExamStatus.onBreak,
        breakEndTime: DateTime.now().add(const Duration(minutes: 30)),
      ),
    );
    hideLoading();
  }

  void startNextSection() {
    if (isClosed || state.examModel == null) return;
    showLoading();
    final newEndTimes = Map<int, String>.from(state.sectionEndTimes);
    if (!newEndTimes.containsKey(2)) {
      final endTime = DateTime.now().add(const Duration(minutes: 120));
      newEndTimes[2] = endTime.toIso8601String();
    }

    emit(
      state.copyWith(
        status: ExamStatus.loading,
        clearBreakTime: true,
        sectionEndTimes: newEndTimes,
        answersStatus: {},
        bookmarkedStatuses: {},
        noteStatuses: {},
      ),
    );
    hideLoading();
    getQuestion(state.examModel!.examId!, 1, 2);
  }

  QuestionActionModel? questionActionModel;
  Future answerQuestion(
    String questionId,
    int questionNo,
    String answer,
  ) async {
    final updatedAnswers = Map<int, String>.from(state.answersStatus);
    updatedAnswers[questionNo] = answer;

    emit(state.copyWith(answersStatus: updatedAnswers));

    final result = await repo.answerQuestion(questionId, answer);
    result.when(
      success: (success) {
        questionActionModel = success;
      },
      failure: (error) {
        hideLoading();
      },
    );
  }

  Future<void> makeQuestionFlag() async {
    if (state.examModel?.data == null) return;

    final questionNo = state.examModel!.data!.questionNo!;
    final questionId = state.examModel!.data!.id.toString();

    final newBookmarkStatus = !(state.bookmarkedStatuses[questionNo] ?? false);
    final updatedBookmarks = Map<int, bool>.from(state.bookmarkedStatuses);
    updatedBookmarks[questionNo] = newBookmarkStatus;

    final updatedQuestion = state.examModel!.data!.copyWith(
      isBookmarked: newBookmarkStatus,
    );
    final updatedExamModel = state.examModel!.copyWith(data: updatedQuestion);

    emit(
      state.copyWith(
        examModel: updatedExamModel,
        bookmarkedStatuses: updatedBookmarks,
      ),
    );

    await repo.makeQuestionFlag(questionId);
  }

  Future<void> addQuestionNote(String note) async {
    if (state.status != ExamStatus.success || state.examModel?.data == null) {
      return;
    }

    final questionNo = state.examModel!.data!.questionNo!;
    final questionId = state.examModel!.data!.id.toString();

    final updatedNotes = Map<int, bool>.from(state.noteStatuses);

    updatedNotes[questionNo] = note.isNotEmpty;

    final updatedQuestion = state.examModel!.data!.copyWith(notes: note);
    final updatedExamModel = state.examModel!.copyWith(data: updatedQuestion);

    emit(
      state.copyWith(examModel: updatedExamModel, noteStatuses: updatedNotes),
    );

    await repo.addQuestionNote(questionId, note);
  }

  Future<void> finishExam() async {
    if (isClosed) return;

    showLoading();
    emit(state.copyWith(status: ExamStatus.loading));

    final result = await repo.finishAnalysisExam();
    hideLoading();
    if (isClosed) return;

    result.when(
      success: (examResultData) {
        emit(
          state.copyWith(
            status: ExamStatus.finished,
            examResult: examResultData,
            answersStatus: {},
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            answersStatus: {},
            status: ExamStatus.success,
            errorMessage: 'Failed to load results. Please try again.',
          ),
        );
      },
    );
  }

  void resetExam() {
    if (isClosed) return;
    emit(const RealExamState(status: ExamStatus.initial));
    clear();
  }
}
