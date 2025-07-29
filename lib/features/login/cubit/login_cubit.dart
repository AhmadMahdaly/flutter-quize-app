import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:smle/core/helpers/extensions.dart';
import 'package:smle/core/shared_widgets/debug_print_widget.dart';
import 'package:smle/features/login/data/model/login_model.dart';
import 'package:smle/features/login/data/repo/login_repo.dart';
import '../../../core/helpers/loading.dart';
import '../../../core/routing/routes.dart';
import '../data/login_api.dart';
part 'login_state.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit(this._loginRepository) : super(LoginInitialState());
  final LoginRepository _loginRepository;
/// logIn With Google
   GoogleSignInAccount? user;
 Future<bool> logInWithGoogle()async{
   try {
    user= await GoogleSignInApi.login();
    user!.authentication.then((googleKey){
      log(user!.id);
      logIn(user!.id,user!.email,user!.displayName!);
      debugPrintWidget(user!.authHeaders.then((onValue){
        debugPrintWidget(onValue);
      }));
    });
    return true;
   } catch (error) {
     debugPrintWidget(error);
     return false;
   } }
  LoginModel? userDataModel;

  Future logIn(String idToken,String email,String name) async {
    showLoading();
    emit(LogInLoadingState());
    final result = await _loginRepository.login( idToken,email,name);
    result.when(success: (success) {
      userDataModel = success;
      hideLoading();
      emit(LogInSuccessState());
      // updateFcmToken();
    }, failure: (error) {
      hideLoading();
    emit(LogInFailedState());

    });
  }
  /// Log Out From Google
  Future<bool> logOut()async{
    try {
      user= await GoogleSignInApi.logOut();
      return true;
    } catch (error) {
      debugPrintWidget(error);
      return false;
    } }



}