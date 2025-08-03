part of 'play_list_cubit.dart';

@immutable
abstract class PlayListStates {}

class PlayListInitialState extends PlayListStates {}

class GetPlayListLoadingState extends PlayListStates {}

class GetPlayListSuccessState extends PlayListStates {}

class GetPlayListFailedState extends PlayListStates {}

class CreatePlayListLoadingState extends PlayListStates {}

class CreatePlayListSuccessState extends PlayListStates {}

class CreatePlayListFailedState extends PlayListStates {}

class DeletePlayListLoadingState extends PlayListStates {}

class DeletePlayListSuccessState extends PlayListStates {}

class DeletePlayListFailedState extends PlayListStates {}

class EditPlayListLoadingState extends PlayListStates {}

class EditPlayListSuccessState extends PlayListStates {}

class EditPlayListFailedState extends PlayListStates {}
