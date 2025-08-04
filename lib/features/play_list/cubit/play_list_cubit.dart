import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smle/core/helpers/loading.dart';
import 'package:smle/features/play_list/data/model/play_list_model.dart';
import 'package:smle/features/play_list/data/repo/play_list_repo.dart';

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
        getPlayList();
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

        getPlayList();
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
        getPlayList();
      },
      failure: (error) {
        hideLoading();
        emit(EditPlayListFailedState());
      },
    );
  }
}
