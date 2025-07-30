import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:smle/core/helpers/loading.dart';
import 'package:smle/core/shared_widgets/debug_print_widget.dart';
import 'package:smle/features/login/data/model/login_model.dart';
import 'package:smle/features/login/data/repo/login_repo.dart';
import '../data/login_api.dart';
part 'login_state.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit(this._loginRepository) : super(LoginInitialState());
  final LoginRepository _loginRepository;

  GoogleSignInAccount? user;
  LoginModel? userDataModel;

  Future<void> logInWithGoogle() async {
    try {
      emit(LogInLoadingState());
      showLoading();

      final googleUser = await GoogleSignInApi.login();
      if (googleUser == null) {
        hideLoading();
        emit(LoginInitialState());
        return;
      }
      user = googleUser;

      await logIn(user!.id, user!.email, user!.displayName!);
    } catch (error) {
      debugPrintWidget('Google Sign-In Error: $error');
      hideLoading();

      emit(
          LogInFailedState('Failed to sign in with Google. Please try again.'));
    }
  }

  Future<void> logIn(String idToken, String email, String name) async {
    final result = await _loginRepository.login(idToken, email, name);

    hideLoading();

    if (isClosed) return;

    result.when(
      success: (success) {
        userDataModel = success;
        emit(LogInSuccessState());
      },
      failure: (error) {
        emit(LogInFailedState(error.errMessage));
      },
    );
  }

  Future<bool> logOut() async {
    try {
      user = await GoogleSignInApi.logOut();
      return true;
    } catch (error) {
      debugPrintWidget(error);
      return false;
    }
  }

  


}