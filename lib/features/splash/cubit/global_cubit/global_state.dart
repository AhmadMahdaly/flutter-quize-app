part of 'global_cubit.dart';
@immutable

 class GlobalStates {

  /// Change Language
  final Locale locale;
  const GlobalStates({ this.locale=const Locale('en')});
}
/// Set onBoarding Index
class SetOnBoardingIndexState extends GlobalStates {
  final int index;
  const SetOnBoardingIndexState(this.index);
}
