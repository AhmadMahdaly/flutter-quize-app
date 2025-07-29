part of 'login_cubit.dart';
@immutable

abstract class LoginStates {}

class LoginInitialState extends LoginStates {}

/// LogIn
class LogInLoadingState extends LoginStates {}
class LogInSuccessState extends LoginStates {}
class LogInFailedState extends LoginStates {}

