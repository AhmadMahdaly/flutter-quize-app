import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smle/core/helpers/loading.dart';
import 'package:smle/core/shared_widgets/debug_print_widget.dart';
import 'package:smle/features/q_bank/data/model/q_bank_model.dart';
import 'package:smle/features/q_bank/data/repo/q_bank_repo.dart';
import 'package:smle/features/revision/data/model/categories_model.dart';
import 'package:smle/features/revision/data/model/subcategories_model.dart';

part 'q_bank_state.dart';

class QBankCubit extends Cubit<QBankStates> {
  QBankCubit(this._qBankRepository) : super(QBankInitialState());
  final QBankRepository _qBankRepository;

  @override
  Future<void> close() {
    numberOfQuestionsController.dispose();
    return super.close();
  }

  // --- تم تطبيق التصحيح هنا ---
  DateTime selectedYearDate = DateTime(2024);
  // -----------------------------

  bool isAllMonthsSelected = true;
  List<int> selectedMonths = [];
  bool isAllYearsSelected = false;
  QBankModel? qBankModel;

  Future<void> init() async {
    _qBankRepository.init();
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
    dynamic apiYear;
    dynamic apiMonth;
    int apiAllMonths = 0;

    if (isAllYearsSelected) {
      apiYear = '2024, 2025';

      // --- التعديل الأول: جعل allMonths يساوي 1 ---
      apiAllMonths = 1;
      // -------------------------------------------

      // ونرسل أيضاً الشهور كما طلبت
      apiMonth = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
    } else {
      apiYear = selectedYearDate.year;

      if (isAllMonthsSelected) {
        apiAllMonths = 1;
        apiMonth = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
      } else {
        apiAllMonths = 0;
        apiMonth = selectedMonths;
      }
    }

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

  void toggleAllMonths(bool selectAll) {
    isAllMonthsSelected = selectAll;
    if (selectAll) {
      selectedMonths.clear();
    } else {
      // عند إلغاء "كل الشهور"، نختار الشهر الحالي من الـ picker كافتراضي
      selectedMonths = [selectedYearDate.month];
    }
    updateAvailableQuestionsCount();
    emit(SelectDateState());
  }

  void toggleAllYears(bool selectAll) {
    isAllYearsSelected = selectAll;
    if (selectAll) {
      isAllMonthsSelected = true; // كما كان في الكود الأصلي
      selectedMonths.clear();
    }
    updateAvailableQuestionsCount();
    emit(SelectDateState());
  }

  int index = 0;
  void setIndexQBank(bool isNext) {
    if (isNext) {
      if (index < (qBankModel?.data?.length ?? 1) - 1) {
        index++;
        // isAnswered = false;
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
    emit(GetSubCategoriesLoadingState());
    aggregatedSubcategories.clear();

    final previousSubCategoryIds = List<int>.from(selectedSubCategoryIds);
    selectedSubCategoryIds.clear();
    selectedSubCategoryNames.clear();

    if (selectedCategoryIds.isEmpty) {
      await updateAvailableQuestionsCount();
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
          failure: (error) {
            debugPrintWidget(
              'Failed to fetch subcategories for category $categoryId',
            );
          },
        );
      }

      final uniqueSubcategories = <int, Subcategories>{};
      for (var sub in allSubcategories) {
        uniqueSubcategories[sub.id!] = sub;
      }
      aggregatedSubcategories = uniqueSubcategories.values.toList();

      for (var sub in aggregatedSubcategories) {
        if (previousSubCategoryIds.contains(sub.id)) {
          selectedSubCategoryIds.add(sub.id!);
          selectedSubCategoryNames.add(sub.name!);
        }
      }

      await updateAvailableQuestionsCount();
      emit(GetSubCategoriesSuccessState());
    } catch (e) {
      emit(GetSubCategoriesFailedState());
    }
  }

  int questionsCount = 0;
  final TextEditingController numberOfQuestionsController =
      TextEditingController();
  bool unansweredOnly = false;
  void selectYear(DateTime selected) {
    selectedYearDate = selected;
    updateAvailableQuestionsCount();
    emit(SelectDateState());
  }

  void toggleMonthSelection(int month) {
    if (isAllMonthsSelected) return; // لا تفعل شيئاً إذا كان "كل الشهور" مفعل

    if (selectedMonths.contains(month)) {
      selectedMonths.remove(month);
    } else {
      selectedMonths.add(month);
    }
    selectedMonths = selectedMonths.toSet().toList(); // منع التكرار
    updateAvailableQuestionsCount();
    emit(SelectDateState());
  }

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
    dynamic apiYear;
    dynamic apiMonth;
    int apiAllMonths = 0;

    if (isAllYearsSelected) {
      apiYear = '2024, 2025';

      // --- التعديل الأول: جعل allMonths يساوي 1 ---
      apiAllMonths = 1;
      // -------------------------------------------

      // ونرسل أيضاً الشهور كما طلبت
      apiMonth = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
    } else {
      apiYear = selectedYearDate.year;

      if (isAllMonthsSelected) {
        apiAllMonths = 1;
        apiMonth = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
      } else {
        apiAllMonths = 0;
        apiMonth = selectedMonths;
      }
    }
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
    // selectedAnswer = key;
    qBankModel!.data![index].selectedAnswer = key;
    // isAnswered = true;
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
      limit: 1, // سؤال واحد فقط
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
        index = 0; // دائماً index=0 لأن limit=1
        isAnswered = false;
        // selectedAnswer = null;
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
    final questionId = currentQuestion.id ?? currentQuestion.questionbankId;

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
