import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/helpers/loading.dart';
import '../data/model/play_list_model.dart';
import '../data/repo/play_list_repo.dart';

part 'play_list_state.dart';

class PlayListCubit extends Cubit<PlayListStates> {
  PlayListCubit(this._playListRepository) : super( PlayListInitialState());
  final PlayListRepository _playListRepository;

  /// Get PlayList
  PlayListModel? playListModel;
  Future getPlayList() async {
    showLoading();
    emit(GetPlayListLoadingState());
    final result = await _playListRepository.getPlayList();
    result.when(success: (success) {
      playListModel = success;
      hideLoading();
      emit(GetPlayListSuccessState());
    }, failure: (error) {
      hideLoading();
      emit(GetPlayListFailedState());
    });
  }

  /// Get PlayList Details
  // PlayListModel? playListModel;
  Future getPlayListDetails() async {
    showLoading();
    emit(GetPlayListLoadingState());
    final result = await _playListRepository.getPlayListDetails();
    result.when(success: (success) {
      playListModel = success;
      hideLoading();
      emit(GetPlayListSuccessState());
    }, failure: (error) {
      hideLoading();
      emit(GetPlayListFailedState());
    });
  }

  /// Create PlayList
  Future createPlayList(String playListName,int? questionId) async {
    showLoading();
    emit(CreatePlayListLoadingState());
    final result = await _playListRepository.createPlayList(playListName,questionId);
    result.when(success: (success) {
      hideLoading();
      emit(CreatePlayListSuccessState());
    }, failure: (error) {
      hideLoading();
      emit(CreatePlayListFailedState());
    });
  }

  /// Delete PlayList
  Future deletePlayList(String playListId) async {
    showLoading();
    emit(DeletePlayListLoadingState());
    final result = await _playListRepository.deletePlayList(playListId);
    result.when(success: (success) {
      hideLoading();
      emit(DeletePlayListSuccessState());
    }, failure: (error) {
      hideLoading();
      emit(DeletePlayListFailedState());
    });
  }
  /// Edit PlayList
  Future editPlayList(String playListId,String playListName) async {
    showLoading();
    emit(EditPlayListLoadingState());
    final result = await _playListRepository.editPlayList(playListId,playListName);
    result.when(success: (success) {
      hideLoading();
      emit(EditPlayListSuccessState());
    }, failure: (error) {
      hideLoading();
      emit(EditPlayListFailedState());
    });
  }


    /// Get PlayList Questions
    Future getPlayListQuestions() async {
      showLoading();
      emit(GetPlayListLoadingState());
      final result = await _playListRepository.getPlayList();
      result.when(success: (success) {
        // playListModel = success;
        hideLoading();
        emit(GetPlayListSuccessState());
      }, failure: (error) {
        hideLoading();
        emit(GetPlayListFailedState());
      });
    }

}