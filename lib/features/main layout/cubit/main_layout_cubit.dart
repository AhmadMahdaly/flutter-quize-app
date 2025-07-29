import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smle/core/cache_helper/cache_helper.dart';
import 'package:smle/core/cache_helper/cache_values.dart';
import 'package:smle/core/helpers/extensions.dart';
import 'package:smle/core/helpers/loading.dart';
import 'package:smle/core/routing/routes.dart';
import 'package:smle/features/main%20layout/data/model/profile_model.dart';
import '../../../core/constants.dart';
import '../data/repo/main_layout_repo.dart';
part 'main_layout_state.dart';

class MainLayoutCubit extends Cubit<MainLayoutState> {
  MainLayoutCubit(this._mainLayoutRepository) : super(MainLayoutInitial());
  static MainLayoutCubit get(context) => BlocProvider.of(context);
  final MainLayoutRepository _mainLayoutRepository;

  void changeBottomNavBar(index) {
    mainLayoutInitialScreenIndex = index;
    emit(AppBottomNavState(mainLayoutInitialScreenIndex));
  }
  /// Get Profile
  ProfileModel? profileModel;
  Future getProfile() async {
    showLoading();
    emit(GetProfileLoadingState());
    final result = await _mainLayoutRepository.getProfile();
    result.when(success: (success) {
      profileModel = success;
      hideLoading();
      emit(GetProfileSuccessState());
    }, failure: (error) {
      hideLoading();
      emit(GetProfileFailedState());
    });
  }

  /// Delete Account
  Future deleteAccount(BuildContext context) async {
    showLoading();
    emit(DeleteAccountLoadingState());
    final result = await _mainLayoutRepository.deleteAccount();
    result.when(success: (success) {
      CacheHelper.sharedPreferences.remove(CacheKeys.userToken);
      context.pushReplacementNamed(Routes.loginScreen);
      hideLoading();
      emit(DeleteAccountSuccessState());
    }, failure: (error) {
      hideLoading();
      emit(DeleteAccountFailedState());
    });
  }
}
