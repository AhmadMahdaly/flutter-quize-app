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

  Future<void> fetchExamsHistory() async {
    showLoading();

    emit(ExamsHistoryLoading());
    final result = await _repository.getExamsHistory();
    result.when(
      success: (examsHistoryModel) {
        allExams = examsHistoryModel.data ?? [];

        hideLoading();
        emit(ExamsHistorySuccess());
      },
      failure: (error) {
        hideLoading();
        emit(ExamsHistoryFailure(error.errMessage));
      },
    );
  }

  Future<void> deleteExamHistory(String examId) async {
    showLoading();

    emit(DeleteExamHistoryLoading());
    final result = await _repository.deleteExamHistory(examId);
    result.when(
      success: (s) async {
        // 1. قم بحذف الاختبار من القائمة المحلية (allExams) بناءً على الـ ID
        allExams.removeWhere((exam) => exam.examId.toString() == examId);

        hideLoading();
        // 2. إصدار حالة نجاح الحذف (إذا كنت تستخدمها لإظهار رسالة مثلاً)
        emit(DeleteExamHistorySuccess(s.toString()));

        // 3. الأهم: إصدار حالة ExamsHistorySuccess لكي يقوم BlocBuilder بإعادة رسم الكروت المتبقية
        emit(ExamsHistorySuccess());
      },
      failure: (error) {
        hideLoading();
        emit(DeleteExamHistoryFailure(error.errMessage));
      },
    );
  }
}
