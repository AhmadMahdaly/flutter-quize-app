import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:smle/core/cache_helper/cache_helper.dart';
import 'package:smle/core/cache_helper/cache_values.dart';
import 'package:smle/features/auth/data/login_api.dart';
import 'package:smle/features/auth/data/repo/login_repo.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit(this._loginRepository) : super(LoginInitialState());
  final LoginRepository _loginRepository;

  Future<void> logInWithGoogle() async {
    try {
      emit(LogInLoadingState());

      final googleUser = await GoogleSignInApi.login();
      if (googleUser == null) {
        emit(LoginInitialState());
        return;
      }

      await _executeLogin(
        id: googleUser.id,
        email: googleUser.email,
        name: googleUser.displayName,
      );
    } catch (error) {
      emit(LogInFailedState('Failed to sign in with Google: $error'));
    }
  }

  Future<void> logInWithApple() async {
    try {
      emit(LogInLoadingState());

      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      log(appleCredential.toString());
      await _executeLogin(
        id: appleCredential.userIdentifier!,
        email: appleCredential.email,
        name: appleCredential.givenName,
      );
    } catch (error) {
      emit(LogInFailedState('Failed to sign in with Apple: $error'));
    }
  }

  Future<void> _executeLogin({
    required String id,
    String? email,
    String? name,
    String? fcmToken,
  }) async {
    final result = await _loginRepository.login(
      id: id,
      email: email,
      name: name,
      fcmToken: fcmToken,
    );

    result.when(
      success: (loginModel) => emit(LogInSuccessState()),
      failure: (error) => emit(LogInFailedState(error.errMessage)),
    );
  }

  Future<void> logOut() async {
    emit(LogOutLoadingState());
    try {
      await GoogleSignInApi.logOut();

      await CacheHelper.removeData(key: CacheKeys.userToken);

      emit(LogOutSuccessState());
    } catch (error) {
      emit(LogOutFailedState('Failed to log out: $error'));
    }
  }
}
