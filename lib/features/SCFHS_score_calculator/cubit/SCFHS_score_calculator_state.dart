part of 'SCFHS_score_calculator_cubit.dart';
@immutable

abstract class SCFHSScoreCalculatorStates {}

class SCFHSScoreCalculatorInitialState extends SCFHSScoreCalculatorStates {}

/// Get Calculator Info
class GetCalculatorInfoLoadingState extends SCFHSScoreCalculatorStates {}
class GetCalculatorInfoSuccessState extends SCFHSScoreCalculatorStates {}
class GetCalculatorInfoFailedState extends SCFHSScoreCalculatorStates {}

/// Select Cv Check List Id
class SelectCvIdState extends SCFHSScoreCalculatorStates {}

/// Get Calculate Result
class GetCalculateResultLoadingState extends SCFHSScoreCalculatorStates {}
class GetCalculateResultSuccessState extends SCFHSScoreCalculatorStates {}
class GetCalculateResultFailedState extends SCFHSScoreCalculatorStates {}