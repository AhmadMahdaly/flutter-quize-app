part of 'login_cubit.dart';
@immutable

abstract class LoginStates {}

class LoginInitialState extends LoginStates {}

/// LogIn
class LogInLoadingState extends LoginStates {}
class LogInSuccessState extends LoginStates {}
class LogInFailedState extends LoginStates {}

/// Delete Account
class DeleteAccountLoadingState extends LoginStates {}
class DeleteAccountSuccessState extends LoginStates {}
class DeleteAccountFailedState extends LoginStates {}