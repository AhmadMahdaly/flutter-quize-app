part of 'login_cubit.dart';

@immutable
@immutable
abstract class LoginStates {}

class LoginInitialState extends LoginStates {}

class LogInLoadingState extends LoginStates {}

class LogInSuccessState extends LoginStates {}

class LogInFailedState extends LoginStates {
  LogInFailedState(this.message);
  final String message;
}

class DeleteAccountLoadingState extends LoginStates {}

class DeleteAccountSuccessState extends LoginStates {}

class DeleteAccountFailedState extends LoginStates {}
