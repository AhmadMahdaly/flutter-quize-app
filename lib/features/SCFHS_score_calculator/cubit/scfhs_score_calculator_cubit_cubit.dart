import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smle/core/helpers/loading.dart';
import 'package:smle/features/SCFHS_score_calculator/data/model/calculate_result_model.dart';
import 'package:smle/features/SCFHS_score_calculator/data/model/calculator_info_model.dart';
import 'package:smle/features/SCFHS_score_calculator/data/repo/calculator_repo.dart';

part 'scfhs_score_calculator_cubit_state.dart';

class ScfhsScoreCalculatorCubit extends Cubit<ScfhsScoreCalculatorStates> {
  ScfhsScoreCalculatorCubit(this._calculatorRepository)
    : super(SCFHSScoreCalculatorInitialState());
  final CalculatorRepository _calculatorRepository;

  /// Get Calculator Info
  CalculatorInfoModel? calculatorInfoModel;
  Future getCalculatorInfo() async {
    showLoading();
    emit(GetCalculatorInfoLoadingState());
    final result = await _calculatorRepository.getCalculatorInfo();
    result.when(
      success: (success) {
        calculatorInfoModel = success;
        hideLoading();
        emit(GetCalculatorInfoSuccessState());
      },
      failure: (error) {
        hideLoading();
        emit(GetCalculatorInfoFailedState());
      },
    );
  }

  /// Select Cv Check List Id
  List<int> selectedCvIds = [];
  void selectCvCheckList(int selectedId) {
    if (!selectedCvIds.contains(selectedId)) {
      selectedCvIds.add(selectedId);
    } else {
      selectedCvIds.remove(selectedId);
    }
    emit(SelectCvIdState());
  }

  /// Entered Info
  TextEditingController realExamController = TextEditingController();
  TextEditingController gpaController = TextEditingController();

  /// Get Calculate Result
  CalculateResultModel? calculateResultModel;
  Future<CalculateResultModel?> getCalculateResult() async {
    showLoading();
    emit(GetCalculateResultLoadingState());
    final result = await _calculatorRepository.calculateScfhs(
      realExamController.text,
      gpaController.text,
      selectedCvIds,
    );
    result.when(
      success: (success) {
        calculateResultModel = success;
        hideLoading();
        emit(GetCalculateResultSuccessState());
      },
      failure: (error) {
        hideLoading();
        emit(GetCalculateResultFailedState());
      },
    );
    return calculateResultModel;
  }
}
