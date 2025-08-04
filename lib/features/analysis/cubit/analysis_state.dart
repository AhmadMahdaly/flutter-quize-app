part of 'analysis_cubit.dart';
@immutable

abstract class AnalysisStates {}

class AnalysisInitialState extends AnalysisStates {}

class GetAnalysisLoadingState extends AnalysisStates {}
class GetAnalysisSuccessState extends AnalysisStates {}
class GetAnalysisFailedState extends AnalysisStates {}
