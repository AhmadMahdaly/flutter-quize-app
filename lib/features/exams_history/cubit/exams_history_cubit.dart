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
    // 1. البحث عن العنصر وحفظه (تحسباً لفشل الحذف من السيرفر حتى نتمكن من إرجاعه)
    final index = allExams.indexWhere(
      (exam) => exam.examId.toString() == examId,
    );
    final deletedExam = index != -1 ? allExams[index] : null;

    // 2. الحذف محلياً وتحديث الواجهة *فوراً* لتجنب خطأ الـ Dismissible
    allExams.removeWhere((exam) => exam.examId.toString() == examId);
    emit(ExamsHistorySuccess());

    // 3. إظهار التحميل وإرسال الطلب للسيرفر
    showLoading();
    emit(ExamsHistoryLoading());

    final result = await _repository.deleteExamHistory(examId);

    result.when(
      success: (s) async {
        hideLoading();
        emit(ExamsHistorySuccess());
      },
      failure: (error) {
        hideLoading();

        // 4. في حالة فشل السيرفر، نقوم بإرجاع الاختبار للقائمة وتحديث الشاشة
        if (deletedExam != null && index != -1) {
          allExams.insert(index, deletedExam);
          emit(ExamsHistorySuccess()); // إعادة رسم الكروت
        }

        emit(ExamsHistoryFailure(error.errMessage));
      },
    );
  }
}
