part of 'scfhs_score_calculator_cubit_cubit.dart';

@immutable
abstract class ScfhsScoreCalculatorStates {}

class SCFHSScoreCalculatorInitialState extends ScfhsScoreCalculatorStates {}

/// Get Calculator Info
class GetCalculatorInfoLoadingState extends ScfhsScoreCalculatorStates {}

class GetCalculatorInfoSuccessState extends ScfhsScoreCalculatorStates {}

class GetCalculatorInfoFailedState extends ScfhsScoreCalculatorStates {}

/// Select Cv Check List Id
class SelectCvIdState extends ScfhsScoreCalculatorStates {}

/// Get Calculate Result
class GetCalculateResultLoadingState extends ScfhsScoreCalculatorStates {}

class GetCalculateResultSuccessState extends ScfhsScoreCalculatorStates {}

class GetCalculateResultFailedState extends ScfhsScoreCalculatorStates {}
