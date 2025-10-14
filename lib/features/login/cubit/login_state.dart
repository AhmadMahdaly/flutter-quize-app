part of 'login_cubit.dart';

// STATES
@immutable
abstract class LoginStates {}

class LoginInitialState extends LoginStates {}

class LogInLoadingState extends LoginStates {}

class LogInSuccessState extends LoginStates {}

class LogInFailedState extends LoginStates {
  LogInFailedState(this.message);
  final String message;
}

class LogOutLoadingState extends LoginStates {}

class LogOutSuccessState extends LoginStates {}

class LogOutFailedState extends LoginStates {
  LogOutFailedState(this.message);
  final String message;
}
