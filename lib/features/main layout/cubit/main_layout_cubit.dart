// ignore_for_file: strict_top_level_inference

import 'package:equatable/equatable.dart';
import 'package:smle/core/cache_helper/cache_helper.dart';
import 'package:smle/core/cache_helper/cache_values.dart';
import 'package:smle/core/helpers/loading.dart';
import 'package:smle/core/helpers/safe_cubit.dart';
import 'package:smle/features/gifts/models/gift_model.dart';
import 'package:smle/features/main%20layout/data/model/profile_model.dart';
import 'package:smle/features/main%20layout/data/repo/main_layout_repo.dart';

part 'main_layout_state.dart';

class MainLayoutCubit extends SafeCubit<MainLayoutState> {
  MainLayoutCubit(this._mainLayoutRepository) : super(MainLayoutInitial());
  final MainLayoutRepository _mainLayoutRepository;
  int mainLayoutInitialScreenIndex = 1;
  int backPressCount = 0;

  void resetBackPress() {
    backPressCount = 0;
  }

  void changeBottomNavBar(index) {
    if (index == mainLayoutInitialScreenIndex) return;
    resetBackPress();
    mainLayoutInitialScreenIndex = index;
    emit(AppBottomNavState(mainLayoutInitialScreenIndex));
  }

  /// Get Profile
  ProfileModel? profileModel;
  Future getProfile() async {
    showLoading();
    emit(GetProfileLoadingState());
    final result = await _mainLayoutRepository.getProfile();
    result.when(
      success: (success) {
        profileModel = success;
        hideLoading();
        emit(GetProfileSuccessState());
      },
      failure: (error) {
        hideLoading();
        emit(GetProfileFailedState());
      },
    );
  }

  clearDataOnLogOut() async {
    profileModel = null;
    giftsResponse = null;

    mainLayoutInitialScreenIndex = 1;
    await CacheHelper.sharedPreferences.remove(CacheKeys.userToken);

    emit(MainLayoutInitial());
  }

  /// Get Gifts
  InvoicesResponseModel? giftsResponse;

  List<InvoiceModel> gifts = [];

  int currentPage = 1;
  int lastPage = 1;

  bool isLoadingMore = false;
  Future<void> getGifts({bool isLoadMore = false}) async {
    if (isLoadingMore) return;

    if (isLoadMore && currentPage > lastPage) return;
    if (isLoadMore) {
      if (isLoadingMore) return; // الحل هنا
      if (currentPage > lastPage) return;

      isLoadingMore = true;
      emit(GetGiftsLoadMoreState());
    } else {
      currentPage = 1;
      gifts.clear();
      emit(GetGiftsLoadingState());
    }

    final result = await _mainLayoutRepository.getGifts(currentPage);

    result.when(
      success: (response) {
        giftsResponse = response;

        lastPage = response.meta?.lastPage ?? 1;

        gifts.addAll(response.data);

        currentPage++;

        isLoadingMore = false;

        emit(GetGiftsSuccessState());
      },
      failure: (error) {
        isLoadingMore = false;
        emit(GetGiftsFailedState());
      },
    );
  }

  /// Delete Account
  Future deleteAccount() async {
    showLoading();
    emit(DeleteAccountLoadingState());
    final result = await _mainLayoutRepository.deleteAccount();
    result.when(
      success: (success) {
        changeBottomNavBar(1);
        hideLoading();
        emit(DeleteAccountSuccessState());
      },
      failure: (error) {
        hideLoading();
        emit(DeleteAccountFailedState());
      },
    );
  }
}
