import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:smle/core/helpers/loading.dart';
import 'package:smle/core/network/failures.dart';
import 'package:smle/features/free_trial/data/models/trial_exam_model.dart';
import 'package:smle/features/free_trial/data/repo/free_trial_repo.dart';

part 'free_trial_state.dart';

class TrialExamCubit extends Cubit<TrialExamState> {
  TrialExamCubit(this._repository) : super(const TrialExamState());
  final TrialExamRepository _repository;

  Future<void> fetchTrialExam() async {
    print('fetchTrialExam called'); // للتصحيح: تحقق في console
    showLoading();

    emit(state.copyWith(status: FetchStatus.loading));
    final result = await _repository.getTrialExam();
    result.when(
      success: (success) {
        final questions = result.data.data;
        hideLoading();

        emit(
          state.copyWith(
            status: FetchStatus.success,
            questions: questions,
            currentQuestionIndex: 0,
            userAnswers: const {}, // مسح الإجابات
            errorMessage: null, // مسح أي خطأ سابق
          ),
        );
        print('fetchTrialExam success: ${questions.length} questions loaded'); // للتصحيح
      },
      failure: (ServerFailure errorHandler) {
        hideLoading();

        emit(
          state.copyWith(
            status: FetchStatus.failure,
            errorMessage: 'Failed to load questions.',
          ),
        );
        print('fetchTrialExam failure: ${errorHandler.errMessage}'); // للتصحيح
      },
    );
  }

  // دالة جديدة لإعادة تعيين الاختبار بالكامل
  Future<void> resetExam() async {
    print('resetExam called'); // للتصحيح
    // إعادة تعيين الحالة إلى الأولية أولاً لإعادة بناء الشاشة
    emit(const TrialExamState());
    // ثم تحميل الاختبار الجديد
    await fetchTrialExam();
  }

  void answerQuestion(int questionId, String selectedOption) {
    if (state.userAnswers.containsKey(questionId)) return;
    final newAnswers = Map<int, String>.from(state.userAnswers);
    newAnswers[questionId] = selectedOption;
    emit(state.copyWith(userAnswers: newAnswers));
  }

  void goToNext() {
    if (state.currentQuestionIndex < state.questions.length - 1) {
      emit(
        state.copyWith(currentQuestionIndex: state.currentQuestionIndex + 1),
      );
    }
  }

  void goToPrevious() {
    if (state.currentQuestionIndex > 0) {
      emit(
        state.copyWith(currentQuestionIndex: state.currentQuestionIndex - 1),
      );
    }
  }

  void goToIndex(int index) {
    if (index >= 0 && index < state.questions.length) {
      emit(state.copyWith(currentQuestionIndex: index));
    }
  }
}