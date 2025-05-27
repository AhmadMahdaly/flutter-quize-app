part of 'play_list_cubit.dart';
@immutable

abstract class PlayListStates {}

class PlayListInitialState extends PlayListStates {}

/// Get PlayList
class GetPlayListLoadingState extends PlayListStates {}
class GetPlayListSuccessState extends PlayListStates {}
class GetPlayListFailedState extends PlayListStates {}


/// Create PlayList
class CreatePlayListLoadingState extends PlayListStates {}
class CreatePlayListSuccessState extends PlayListStates {}
class CreatePlayListFailedState extends PlayListStates {}

/// Delete PlayList
class DeletePlayListLoadingState extends PlayListStates {}
class DeletePlayListSuccessState extends PlayListStates {}
class DeletePlayListFailedState extends PlayListStates {}

/// Edit PlayList
class EditPlayListLoadingState extends PlayListStates {}
class EditPlayListSuccessState extends PlayListStates {}
class EditPlayListFailedState extends PlayListStates {}

