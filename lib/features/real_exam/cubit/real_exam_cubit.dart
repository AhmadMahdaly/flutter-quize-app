import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smle/core/helpers/loading.dart';
import 'package:smle/features/real_exam/data/model/finish_analysis_exam.dart';
import 'package:smle/features/real_exam/data/model/get_real_exam_model.dart';
import 'package:smle/features/real_exam/data/model/post_real_exam_model.dart';
import 'package:smle/features/real_exam/data/model/question_action_model.dart';
import 'package:smle/features/real_exam/data/repo/real_exam_repo.dart';

part 'real_exam_state.dart';

class RealExamCubit extends Cubit<RealExamState> {
  RealExamCubit(this.repo) : super(RealExamInitialState());
  final RealExamRepo repo;
  StartRealExamModel? startRealExamModel;
  Future startRealExam() async {
    showLoading();
    emit(StartRealExamLoadingState());

    final result = await repo.startRealExam();
    result.when(success: (success) {
      startRealExamModel = success;
      hideLoading();
      emit(StartRealExamSuccessState());
    }, failure: (error) {
      hideLoading();
      emit(StartRealExamFailedState());
    });
  }

  int currentIndex = 0;
  void goToNext(data) {
    if (currentIndex < data.length - 1) {
      currentIndex++;
    }
  }

  void goToPrevious() {
    if (currentIndex > 0) {
      currentIndex--;
    }
  }

  void goToIndex(int index) {
    emit(state.copyWith(currentIndex: index));
  }

  Future getQuestion(int examId, int qNo, int section) async {
    showLoading();
    emit(GetQuestionLoadingState());

    final result = await repo.getQuestion(examId, qNo, section);
    result.when(success: (success) {
      startRealExamModel = success;
      hideLoading();
      emit(GetQuestionSuccessState());
    }, failure: (error) {
      hideLoading();
      emit(GetQuestionFailedState());
    });
  }

  List<int> postRealExamOffsetList = [];
  int offset = 0;
  PostRealExamModel? postRealExamModel;
  Future getRealExamQuestions(int limit, int examId, bool isHistory) async {
    if (!postRealExamOffsetList.contains(offset)) {
      postRealExamOffsetList.add(offset);

      showLoading();
      emit(GetRealExamQLoadingState());

      final result =
          await repo.getRealExamQuestions(offset, limit, examId, isHistory);
      result.when(success: (success) {
        postRealExamModel = success;
        hideLoading();
        emit(GetRealExamQSuccessState());
      }, failure: (error) {
        hideLoading();
        emit(GetRealExamQFailedState());
      });
    }
  }

  QuestionActionModel? questionActionModel;
  Future answerQuestion(String questionId, String answer) async {
    showLoading();
    emit(AnswerQLoadingState());
    final result = await repo.answerQuestion(questionId, answer);
    result.when(success: (success) {
      questionActionModel = success;
      hideLoading();
      emit(AnswerQSuccessState());
    }, failure: (error) {
      hideLoading();
      emit(AnswerQFailedState());
    });
  }

  Future makeQuestionFlag(String questionId) async {
    showLoading();
    emit(MakeFlagLoadingState());
    final result = await repo.makeQuestionFlag(questionId);
    result.when(success: (success) {
      questionActionModel = success;
      hideLoading();
      emit(MakeFlagSuccessState());
    }, failure: (error) {
      hideLoading();
      emit(MakeFlagFailedState());
    });
  }

  Future addQuestionNote(String questionId, String note) async {
    showLoading();
    emit(AddNoteLoadingState());
    final result = await repo.addQuestionNote(questionId, note);
    result.when(success: (success) {
      questionActionModel = success;
      hideLoading();
      emit(AddNoteSuccessState());
    }, failure: (error) {
      hideLoading();
      emit(AddNoteFailedState());
    });
  }

  FinishAnalysisExamModel? finishAnalysisExamModel;
  Future finishAnalysisExam() async {
    showLoading();
    emit(FinishAnalysisExamLoadingState());
    final result = await repo.finishAnalysisExam();
    result.when(success: (success) {
      finishAnalysisExamModel = success;
      hideLoading();
      emit(FinishAnalysisExamSuccessState());
    }, failure: (error) {
      hideLoading();
      emit(FinishAnalysisExamFailedState());
    });
  }

  Future examHistory(int offset, int limit) async {
    showLoading();
    emit(ExamHistoryLoadingState());
    final result = await repo.examHistory(
      offset,
      limit,
    );
    result.when(success: (success) {
      finishAnalysisExamModel = success;
      hideLoading();
      emit(ExamHistorySuccessState());
    }, failure: (error) {
      hideLoading();
      emit(ExamHistoryFailedState());
    });
  }
}