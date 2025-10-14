import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smle/core/helpers/loading.dart';
import 'package:smle/features/play_list/data/model/play_list_model.dart';
import 'package:smle/features/play_list/data/repo/play_list_repo.dart';
import 'package:smle/features/q_bank/data/model/q_bank_model.dart';

part 'play_list_state.dart';

class PlayListCubit extends Cubit<PlayListStates> {
  PlayListCubit(this._playListRepository) : super(PlayListInitialState());
  final PlayListRepository _playListRepository;

  PlayListModel? playListModel;

  /// Get PlayList
  Future<void> getPlayList() async {
    showLoading();
    emit(GetPlayListLoadingState());
    final result = await _playListRepository.getPlayList();
    result.when(
      success: (success) {
        playListModel = success;
        hideLoading();
        emit(GetPlayListSuccessState());
      },
      failure: (error) {
        hideLoading();
        emit(GetPlayListFailedState());
      },
    );
  }

  /// Create PlayList
  Future<void> createPlayList(String playListName, int? questionId) async {
    showLoading();
    emit(CreatePlayListLoadingState());
    final result = await _playListRepository.createPlayList(
      playListName,
      questionId,
    );
    result.when(
      success: (success) {
        hideLoading();
        emit(CreatePlayListSuccessState());
        getPlayList(); // تحديث القائمة
      },
      failure: (error) {
        hideLoading();
        emit(CreatePlayListFailedState());
      },
    );
  }

  /// Delete PlayList
  Future<void> deletePlayList(String playListId) async {
    showLoading();
    emit(DeletePlayListLoadingState());
    final result = await _playListRepository.deletePlayList(playListId);
    result.when(
      success: (success) {
        hideLoading();
        emit(DeletePlayListSuccessState());
        getPlayList(); // تحديث القائمة
      },
      failure: (error) {
        hideLoading();
        emit(DeletePlayListFailedState());
      },
    );
  }


  /// Edit PlayList
  Future<void> editPlayList(String playListId, String playListName) async {
    showLoading();
    emit(EditPlayListLoadingState());
    final result = await _playListRepository.editPlayList(
      playListId,
      playListName,
    );
    result.when(
      success: (success) {
        hideLoading();
        emit(EditPlayListSuccessState());
        getPlayList(); // تحديث القائمة
      },
      failure: (error) {
        hideLoading();
        emit(EditPlayListFailedState());
      },
    );
  }
  Future<void> addToPlayList(String playListId, String questionId) async {
    showLoading();
    emit(AddToPlayListLoadingState());
    final result = await _playListRepository.addToPlayList(playListId, questionId);
    result.when(
      success: (success) {
        hideLoading();
        emit(AddToPlayListSuccessState());
        getPlayList();
      },
      failure: (error) {
        hideLoading();
        emit(AddToPlayListFailedState());
      },
    );
  }
  Future<void> removeFromPlayList(String playListId, String questionId, {int? offset}) async {
    showLoading();
    emit(RemoveFromPlayListLoadingState());
    final result = await _playListRepository.removeFromPlayList(playListId, questionId);
    result.when(
      success: (success) {
        hideLoading();
        emit(RemoveFromPlayListSuccessState());
        getPlayList();
        if (offset != null) {
          getPlayListDetails(
            playlistId: playListId,
            limit: 1,
            offset: offset,
          );
        }
      },
      failure: (error) {
        hideLoading();
        emit(RemoveFromPlayListFailedState());
      },
    );
  }

  QBankModel? playListQuestionsModel; // غير إلى QBankModel للأسئلة

  Future<void> getPlayListDetails({
    required String playlistId,
    int limit = 1,
    int offset = 0,
  }) async {
    showLoading();
    emit(GetPlayListDetailsLoadingState());
    final result = await _playListRepository.getPlayListDetails(
      playlistId: playlistId,
      limit: limit,
      offset: offset,
    );
    result.when(
      success: (success) {
        playListQuestionsModel = success;
        hideLoading();
        emit(GetPlayListDetailsSuccessState());
      },
      failure: (error) {
        hideLoading();
        emit(GetPlayListDetailsFailedState());
      },
    );
  }
}
