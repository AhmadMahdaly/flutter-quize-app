import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'analysis_state.dart';

class AnalysisCubit extends Cubit<AnalysisStates> {
  AnalysisCubit() : super( AnalysisInitialState());


}