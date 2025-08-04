part of 'global_cubit.dart';
@immutable

 class GlobalStates {
  const GlobalStates({ this.locale=const Locale('en')});

  /// Change Language
  final Locale locale;
}
/// Set onBoarding Index
class SetOnBoardingIndexState extends GlobalStates {
  const SetOnBoardingIndexState(this.index);
  final int index;
}
