import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smle/core/helpers/extensions.dart';
import 'package:smle/features/q_bank/data/repo/q_bank_repo.dart';
import '../../../core/helpers/loading.dart';
import '../../../core/routing/routes.dart';
import '../../revision/data/model/categories_model.dart';
import '../../revision/data/model/subcategories_model.dart';
import '../data/model/q_bank_model.dart';
part 'q_bank_state.dart';

class QBankcubit extends Cubit<QBankStates> {
  QBankcubit(this._qBankRepository) : super(QBankInitialState());
  final QBankRepository _qBankRepository;

  /// Start Quiz (Q Bank)
  QBankModel? qBankModel;
  List<int> questionOffsetList = [];
  int offset =0;
  Future startQuiz(BuildContext context, int month,int year,List<int> subcategoryIds) async {
    if (!questionOffsetList.contains(offset)) {
      questionOffsetList.add(offset);
    showLoading();
    emit(StartQuizLoadingState());
    final result = await _qBankRepository.getQBank( month, year,
        subcategoryIds
        );
    result.when(success: (success) {
      if(offset==0){
        qBankModel = success;
      }else{
        qBankModel!.data!.addAll(success.data!);
      }
      hideLoading();
      emit(StartQuizSuccessState());
    }, failure: (error) {
      hideLoading();
      emit(StartQuizFailedState());
    });
  }
  }
  int index =0;
  setIndexQBank(bool isNext){
    if(isNext){
      index++;
    }else{
      index--;
    }
    emit(SetIndexQuizState());
  }


  setOffsetQBank(bool isNext){
    if(isNext){
      offset++;
    }else{
      offset--;
    }
    emit(SetOffsetQuizState());
  }

  /// Get Categories
  CategoriesModel? categoriesModel;
  Future getCategories() async {
    showLoading();
    emit(GetCategoriesLoadingState());
    final result = await _qBankRepository.getCategories();
    result.when(success: (success) {
      categoriesModel = success;
      hideLoading();
      emit(GetCategoriesSuccessState());
      selectCategory('${categoriesModel!.data![0].name}');
      getSubCategories('${categoriesModel!.data![0].id}');
    }, failure: (error) {
      hideLoading();
      emit(GetCategoriesFailedState());
    });
  }

  /// Get Sub Categories
  SubCategoriesModel? subCategoriesModel;
  Future getSubCategories(String categoryId) async {
    showLoading();
    emit(GetSubCategoriesLoadingState());
    final result = await _qBankRepository.getSubCategories(categoryId);
    result.when(success: (success) {
      subCategoriesModel = success;
      hideLoading();
      emit(GetSubCategoriesSuccessState());
        selectSubCategory([int.parse('${subCategoriesModel!.data!.subcategories![0].id}')],['${subCategoriesModel!.data!.subcategories![0].name}']);
    }, failure: (error) {
      hideLoading();
      emit(GetSubCategoriesFailedState());
    });
  }
  /// Select Date
  DateTime pickedDate=DateTime(2020);
  selectDate(DateTime selected) {
    pickedDate = selected;
    emit(SelectDateState());
  }

  /// Select Category
  String? selectedCategory;
  selectCategory(String selected) {
    selectedCategory = selected;
    emit(SelectCategoryState());
  }

  /// Select Sub Category
  List<int> selectedSubCategoryId=[];
  List<String> selectedSubCategory=[];
  selectSubCategory(List<int> selectedId,List<String> selectedValues) {
    // if(selectedSubCategory==[]){
      selectedSubCategory=selectedValues;
    // }else{
    //   selectedSubCategory.addAll(selectedValues);
    // }
    if(selectedSubCategoryId==[]){
      selectedSubCategoryId=selectedId;
    }else{
      for(int i =0;i<selectedId.length;i++) {
        if(!selectedSubCategoryId.contains(selectedId[i])){
          selectedSubCategoryId.add(selectedId[i]);
        }
    }
    }
    emit(SelectSubCategoryState());
  }
  // String? selectedAnswerKey;
  selectAnswer(key){
    qBankModel!.data![index].selectedAnswer=key;
    emit(SelectAnswerState());
  }

  bool isAnswered=false;
  setIsAnswered(){
    isAnswered= !isAnswered;
    emit(SetIsAnsweredState());
  }
}
