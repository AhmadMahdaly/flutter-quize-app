import 'package:flutter/material.dart';
import 'package:smle/core/helpers/loading.dart';
import 'package:smle/core/helpers/safe_cubit.dart';
import 'package:smle/core/shared_widgets/debug_print_widget.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/features/free_q_bank/data/repo/free_q_bank_repo.dart';
import 'package:smle/features/q_bank/data/model/q_bank_model.dart';
import 'package:smle/features/q_bank/data/model/year_model.dart';
import 'package:smle/features/revision/data/model/categories_model.dart';
import 'package:smle/features/revision/data/model/subcategories_model.dart';

part 'free_q_bank_state.dart';

class FreeQBankCubit extends SafeCubit<FreeQBankStates> {
  FreeQBankCubit(this._qBankRepository) : super(QBankInitialState());
  final FreeQBankRepository _qBankRepository;

  @override
  Future<void> close() {
    numberOfQuestionsController.dispose();
    return super.close();
  }

  bool isSubCategoriesLoading = false;
  DateTime selectedYearDate = DateTime(2024);
  int selectedMonth = DateTime.now().month;

  QBankModel? qBankModel;
  List<int> availableYears = [];
  List<int> availableMonths = [];

  Future<void> init() async {
    _qBankRepository.init();
    await getAvailableYears();
  }

  Map<String, dynamic> calculateResults() {
    int correct = 0;
    int wrong = 0;
    int skipped = 0;

    if (qBankModel?.data != null) {
      for (var question in qBankModel!.data!) {
        if (question.selectedAnswer == null) {
          skipped++;
        } else if (question.selectedAnswer == question.answer) {
          correct++;
        } else {
          wrong++;
        }
      }
    }

    final int total = qBankModel?.data?.length ?? 0;
    // حساب النسبة المئوية
    final double percentage = total == 0 ? 0.0 : (correct / total) * 100;

    Color analysisColor;

    if (percentage >= 80) {
      analysisColor = AppColors.successColor;
    } else if (percentage >= 50) {
      analysisColor = Colors.orange;
    } else {
      analysisColor = Colors.red;
    }

    return {
      'total': total,
      'correct': correct,
      'wrong': wrong,
      'skipped': skipped,
      'percentage': percentage,
      'color': analysisColor,
    };
  }

  YearsModel? yearsModel;
  Future getYears() async {
    showLoading();
    emit(GetYearsLoadingState());
    final result = await _qBankRepository.getYears();
    result.when(
      success: (success) {
        yearsModel = success;

        if (availableYears.isNotEmpty &&
            !availableYears.contains(selectedYearDate.year)) {
          selectedYearDate = DateTime(availableYears.first);
        }

        hideLoading();
        emit(GetYearsSuccessState());
      },
      failure: (error) {
        hideLoading();
        emit(GetYearsFailedState());
      },
    );
  }

  Future<void> getAvailableYears() async {
    emit(GetCategoriesLoadingState());
    final result = await _qBankRepository.getAvailableYears();
    result.when(
      success: (years) {
        availableYears = years;
        if (availableYears.isNotEmpty) {
          selectYear(availableYears.first);
        }
        emit(GetCategoriesSuccessState());
      },
      failure: (error) => emit(GetCategoriesFailedState()),
    );
  }

  Future<void> getAvailableMonths(int year) async {
    emit(GetSubCategoriesLoadingState());
    final result = await _qBankRepository.getAvailableMonths(year);
    result.when(
      success: (monthsData) {
        availableMonths = monthsData
            .map((m) => int.parse(m['value'].toString()))
            .toList();

        if (!availableMonths.contains(selectedMonth) &&
            availableMonths.isNotEmpty) {
          selectedMonth = availableMonths.first;
        }

        emit(GetSubCategoriesSuccessState());
      },
      failure: (error) => emit(GetSubCategoriesFailedState()),
    );
  }

  void selectYear(int year) {
    selectedYearDate = DateTime(year);
    getAvailableMonths(year);
    emit(SelectDateState());
  }

  void toggleMonthSelection(int month) {
    if (availableMonths.contains(month)) {
      selectedMonth = month;

      emit(SelectDateState());
    }
  }

  void setQuizModel(QBankModel model) {
    qBankModel = model;
    index = 0;
    isAnswered = false;
    emit(QuizModelSetState());
  }

  Future<void> getQuestions() async {
    showLoading();
    emit(StartQuizLoadingState());

    final int limit = int.tryParse(numberOfQuestionsController.text) ?? 0;

    final int apiYear = selectedYearDate.year;
    final int apiMonth = selectedMonth;
    final int apiAllMonths = 0;

    final result = await _qBankRepository.startQuiz(
      year: apiYear,
      month: apiMonth,
      allMonths: apiAllMonths,
      subcategoryIds: selectedSubCategoryIds,
      unansweredOnly: unansweredOnly ? 1 : 0,
      limit: limit,
    );

    result.when(
      success: (success) {
        qBankModel = success;
        index = 0;
        isAnswered = false;
        hideLoading();
        emit(StartQuizSuccessState());
      },
      failure: (error) {
        hideLoading();
        emit(StartQuizFailedState());
      },
    );
  }

  int index = 0;
  void setIndexQBank(bool isNext) {
    if (isNext) {
      if (index < (qBankModel?.data?.length ?? 1) - 1) {
        index++;
      }
    } else {
      if (index > 0) {
        index--;
      }
    }
    emit(SetIndexQuizState());
  }

  CategoriesModel? categoriesModel;
  Future getCategories() async {
    emit(GetCategoriesLoadingState());
    final result = await _qBankRepository.getCategories();
    result.when(
      success: (success) {
        categoriesModel = success;

        emit(GetCategoriesSuccessState());
      },
      failure: (error) {
        emit(GetCategoriesFailedState());
      },
    );
  }

  List<Subcategories> aggregatedSubcategories = [];
  Future getSubCategoriesForSelected() async {
    isSubCategoriesLoading = true;
    emit(GetSubCategoriesLoadingState());

    final previousSubCategoryIds = List<int>.from(selectedSubCategoryIds);

    if (selectedCategoryIds.isEmpty) {
      aggregatedSubcategories.clear();
      selectedSubCategoryIds.clear();
      selectedSubCategoryNames.clear();
      await updateAvailableQuestionsCount();
      isSubCategoriesLoading = false;
      emit(GetSubCategoriesSuccessState());
      return;
    }

    try {
      final List<Subcategories> allSubcategories = [];

      for (var categoryId in selectedCategoryIds) {
        final result = await _qBankRepository.getSubCategories('$categoryId');
        result.when(
          success: (success) {
            if (success.data?.subcategories != null) {
              allSubcategories.addAll(success.data!.subcategories!);
            }
          },
          failure: (_) {},
        );
      }

      final unique = <int, Subcategories>{};
      for (var sub in allSubcategories) {
        unique[sub.id!] = sub;
      }

      aggregatedSubcategories = unique.values.toList();

      selectedSubCategoryIds
        ..clear()
        ..addAll(
          aggregatedSubcategories
              .where((e) => previousSubCategoryIds.contains(e.id))
              .map((e) => e.id!),
        );

      selectedSubCategoryNames
        ..clear()
        ..addAll(
          aggregatedSubcategories
              .where((e) => previousSubCategoryIds.contains(e.id))
              .map((e) => e.name!),
        );

      await updateAvailableQuestionsCount();
      emit(GetSubCategoriesSuccessState());
    } catch (_) {
      emit(GetSubCategoriesFailedState());
    }
  }

  int questionsCount = 0;
  final TextEditingController numberOfQuestionsController =
      TextEditingController();
  bool unansweredOnly = false;

  void toggleUnansweredOnly(bool value) {
    unansweredOnly = value;
    updateAvailableQuestionsCount();
    emit(FilterChangedState());
  }

  Future<void> updateAvailableQuestionsCount() async {
    if (selectedSubCategoryIds.isEmpty && selectedCategoryIds.isNotEmpty) {
      questionsCount = 0;
      emit(GetQuestionsCountSuccessState());
      return;
    }

    emit(GetQuestionsCountLoadingState());

    final int apiYear = selectedYearDate.year;
    final int apiMonth = selectedMonth;
    final int apiAllMonths = 0;

    final result = await _qBankRepository.getQuestionsCount(
      year: apiYear,
      month: apiMonth,
      allMonths: apiAllMonths,
      subcategoryIds: selectedSubCategoryIds,
      unansweredOnly: unansweredOnly ? 1 : 0,
    );

    result?.when(
      success: (model) {
        questionsCount = model.count ?? 0;
        final currentInput =
            int.tryParse(numberOfQuestionsController.text) ?? 0;
        if (currentInput > questionsCount) {
          numberOfQuestionsController.clear();
        }
        emit(GetQuestionsCountSuccessState());
      },
      failure: (error) {
        questionsCount = 0;
        emit(GetQuestionsCountFailedState());
      },
    );
  }

  List<int> selectedCategoryIds = [];
  List<String> selectedCategoryNames = [];

  void toggleCategorySelection(int categoryId, String categoryName) {
    if (selectedCategoryIds.contains(categoryId)) {
      selectedCategoryIds.remove(categoryId);
      selectedCategoryNames.remove(categoryName);
    } else {
      selectedCategoryIds.add(categoryId);
      selectedCategoryNames.add(categoryName);
    }
    getSubCategoriesForSelected();
    updateAvailableQuestionsCount();
    emit(SelectCategoryState());
  }

  void selectAllCategories(bool selectAll) async {
    selectedCategoryIds.clear();
    selectedCategoryNames.clear();
    if (selectAll && categoriesModel?.data != null) {
      for (var category in categoriesModel!.data!) {
        selectedCategoryIds.add(category.id!);
        selectedCategoryNames.add(category.name!);
      }
    }
    await getSubCategoriesForSelected();
    if (selectAll) {
      selectAllSubCategories(true);
    } else {
      selectAllSubCategories(false);
    }
    updateAvailableQuestionsCount();
    emit(SelectCategoryState());
  }

  List<int> selectedSubCategoryIds = [];
  List<String> selectedSubCategoryNames = [];

  void toggleSubCategorySelection(int subCategoryId, String subCategoryName) {
    if (selectedSubCategoryIds.contains(subCategoryId)) {
      selectedSubCategoryIds.remove(subCategoryId);
      selectedSubCategoryNames.remove(subCategoryName);
    } else {
      selectedSubCategoryIds.add(subCategoryId);
      selectedSubCategoryNames.add(subCategoryName);
    }
    updateAvailableQuestionsCount();
    emit(SelectSubCategoryState());
  }

  void selectAllSubCategories(bool selectAll) {
    selectedSubCategoryIds.clear();
    selectedSubCategoryNames.clear();
    if (selectAll) {
      for (var subCategory in aggregatedSubcategories) {
        selectedSubCategoryIds.add(subCategory.id!);
        selectedSubCategoryNames.add(subCategory.name!);
      }
    }
    updateAvailableQuestionsCount();
    emit(SelectSubCategoryState());
  }

  void selectAnswer(String key, int questionId) {
    qBankModel!.data![index].selectedAnswer = key;

    markQuestionAsAnswered(questionId);
    emit(SelectAnswerState());
  }

  Future<void> markQuestionAsAnswered(int questionId) async {
    emit(MarkingAsAnsweredState());
    final result = await _qBankRepository.markQuestionAsAnswered(questionId);
    result.when(
      success: (success) {
        debugPrintWidget('Question $questionId marked as answered.');
        emit(MarkAsAnsweredSuccessState());
      },
      failure: (error) {
        debugPrintWidget('Failed to mark question $questionId as answered.');
        emit(MarkAsAnsweredFailedState());
      },
    );
  }

  bool isAnswered = false;
  void setIsAnswered() {
    isAnswered = !isAnswered;
    emit(SetIsAnsweredState());
  }

  Future<void> getPlaylistQuestions(int playlistId, {int offset = 0}) async {
    showLoading();
    emit(GetPlaylistQuestionsLoadingState());
    final result = await _qBankRepository.getPlaylistQuestions(
      playlistId: playlistId,
      limit: 1,
      offset: offset,
    );
    result.when(
      success: (success) {
        if (success.data == null || success.data!.isEmpty) {
          hideLoading();
          emit(PlaylistQuestionsEndState());
          return;
        }
        qBankModel = QBankModel(
          status: success.status,
          message: success.message,
          data: success.data,
        );
        index = 0;
        isAnswered = false;

        hideLoading();
        emit(GetPlaylistQuestionsSuccessState());
      },
      failure: (error) {
        hideLoading();
        emit(GetPlaylistQuestionsFailedState());
      },
    );
  }

  Future<void> addQuestionNote(String note) async {
    final currentQuestion = qBankModel!.data![index];
    final questionId = currentQuestion.id ?? currentQuestion.id;

    if (questionId == null) return;

    emit(AddNoteLoadingState());

    final result = await _qBankRepository.addQBankNote(
      questionId: questionId,
      note: note,
    );

    result.when(
      success: (success) {
        emit(AddNoteSuccessState('Note added successfully'));
      },
      failure: (error) {
        emit(AddNoteFailureState(error.errMessage));
      },
    );
  }
}
