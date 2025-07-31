import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smle/core/helpers/loading.dart';
import 'package:smle/features/exams_history/data/models/exams_history_model.dart';
import 'package:smle/features/exams_history/data/repo/exams_history_repository.dart';

part 'exams_history_state.dart';

class ExamsHistoryCubit extends Cubit<ExamsHistoryState> {
  ExamsHistoryCubit(this._repository) : super(ExamsHistoryInitial());
  final ExamsHistoryRepository _repository;

  List<Exam> allExams = [];
  List<Exam> passedExams = [];
  List<Exam> midLevelExams = [];
  List<Exam> failedExams = [];

  Future<void> fetchExamsHistory() async {
    showLoading();

    emit(ExamsHistoryLoading());
    final result = await _repository.getExamsHistory();
    result.when(
      success: (examsHistoryModel) {
        allExams = examsHistoryModel.data ?? [];
        _filterExams();
        hideLoading();
        emit(ExamsHistorySuccess());
      },
      failure: (error) {
        hideLoading();
        emit(ExamsHistoryFailure(error.errMessage));
      },
    );
  }

  void _filterExams() {
    passedExams.clear();
    midLevelExams.clear();
    failedExams.clear();

    const int passThreshold = 60;
    const int failThreshold = 40;

    for (var exam in allExams) {
      final score = exam.score ?? 0;
      if (score >= passThreshold) {
        passedExams.add(exam);
      } else if (score < failThreshold) {
        failedExams.add(exam);
      } else {
        midLevelExams.add(exam);
      }
    }
  }
}
