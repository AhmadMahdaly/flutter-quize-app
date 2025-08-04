import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smle/core/helpers/loading.dart';
import 'package:smle/features/analysis/data/model/analysis_model.dart';
import 'package:smle/features/analysis/data/repo/analysis_repo.dart';
part 'analysis_state.dart';

class AnalysisCubit extends Cubit<AnalysisStates> {
  AnalysisCubit(this._analysisRepository) : super(AnalysisInitialState());
  final AnalysisRepository _analysisRepository;
  /// Get Analysis
  AnalysisModel? analysisModel;
  Future getAnalysis() async {
    showLoading();
    emit(GetAnalysisLoadingState());
    final result = await _analysisRepository.getAnalysis();
    result.when(success: (success) {
      analysisModel = success;
      hideLoading();
      emit(GetAnalysisSuccessState());
    }, failure: (error) {
      hideLoading();
      emit(GetAnalysisFailedState());
    });
  }
}