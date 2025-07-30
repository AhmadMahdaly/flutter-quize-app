import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smle/core/helpers/loading.dart';
import 'package:smle/features/q_bank/data/model/q_bank_model.dart';
import 'package:smle/features/q_bank/data/repo/q_bank_repo.dart';
import 'package:smle/features/revision/data/model/categories_model.dart';
import 'package:smle/features/revision/data/model/subcategories_model.dart';

part 'q_bank_state.dart';

class QBankcubit extends Cubit<QBankStates> {
  QBankcubit(this._qBankRepository) : super(QBankInitialState());
  final QBankRepository _qBankRepository;

  QBankModel? qBankModel;
  List<int> questionOffsetList = [];
  int offset = 0;
  Future startQuiz(
    BuildContext context,
    int month,
    int year,
    List<int> subcategoryIds,
  ) async {
    if (!questionOffsetList.contains(offset)) {
      questionOffsetList.add(offset);
      showLoading();
      emit(StartQuizLoadingState());
      final result = await _qBankRepository.getQBank(
        month,
        year,
        subcategoryIds,
      );
      result.when(
        success: (success) {
          if (offset == 0) {
            qBankModel = success;
          } else {
            qBankModel!.data!.addAll(success.data!);
          }
          hideLoading();
          emit(StartQuizSuccessState());
        },
        failure: (error) {
          hideLoading();
          emit(StartQuizFailedState());
        },
      );
    }
  }

  int index = 0;
  void setIndexQBank(bool isNext) {
    if (isNext) {
      index++;
    } else {
      index--;
    }
    emit(SetIndexQuizState());
  }

  void setOffsetQBank(bool isNext) {
    if (isNext) {
      offset++;
    } else {
      offset--;
    }
    emit(SetOffsetQuizState());
  }

  CategoriesModel? categoriesModel;
  Future getCategories() async {
    showLoading();
    emit(GetCategoriesLoadingState());
    final result = await _qBankRepository.getCategories();
    result.when(
      success: (success) {
        categoriesModel = success;
        hideLoading();
        emit(GetCategoriesSuccessState());
      },
      failure: (error) {
        hideLoading();
        emit(GetCategoriesFailedState());
      },
    );
  }

  List<Subcategories> aggregatedSubcategories = [];
  Future getSubCategoriesForSelected() async {
    showLoading();
    emit(GetSubCategoriesLoadingState());

    aggregatedSubcategories.clear();
    selectedSubCategoryIds.clear();
    selectedSubCategoryNames.clear();

    if (selectedCategoryIds.isEmpty) {
      hideLoading();
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
            print('Failed to fetch subcategories for category $categoryId');
          },
        );
      }

      final uniqueSubcategories = <int, Subcategories>{};
      for (var sub in allSubcategories) {
        uniqueSubcategories[sub.id!] = sub;
      }
      aggregatedSubcategories = uniqueSubcategories.values.toList();

      hideLoading();
      emit(GetSubCategoriesSuccessState());
    } catch (e) {
      hideLoading();
      emit(GetSubCategoriesFailedState());
    }
  }

  DateTime pickedDate = DateTime(2020);
  void selectDate(DateTime selected) {
    pickedDate = selected;
    emit(SelectDateState());
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
    emit(SelectCategoryState());
  }

  void selectAllCategories(bool selectAll) {
    selectedCategoryIds.clear();
    selectedCategoryNames.clear();
    if (selectAll && categoriesModel?.data != null) {
      for (var category in categoriesModel!.data!) {
        selectedCategoryIds.add(category.id!);
        selectedCategoryNames.add(category.name!);
      }
    }
    getSubCategoriesForSelected();
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
    emit(SelectSubCategoryState());
  }

  void selectAnswer(key) {
    qBankModel!.data![index].selectedAnswer = key;
    emit(SelectAnswerState());
  }

  bool isAnswered = false;
  void setIsAnswered() {
    isAnswered = !isAnswered;
    emit(SetIsAnsweredState());
  }
}
