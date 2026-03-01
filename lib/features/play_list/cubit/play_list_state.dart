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

class AddToPlayListLoadingState extends PlayListStates {}

class AddToPlayListSuccessState extends PlayListStates {}

class AddToPlayListFailedState extends PlayListStates {}

class GetPlayListDetailsLoadingState extends PlayListStates {}

class GetPlayListDetailsSuccessState extends PlayListStates {}

class GetPlayListDetailsFailedState extends PlayListStates {}

class RemoveFromPlayListLoadingState extends PlayListStates {}

class RemoveFromPlayListSuccessState extends PlayListStates {}

class RemoveFromPlayListFailedState extends PlayListStates {}

class AddNoteLoadingState extends PlayListStates {}

class AddNoteSuccessState extends PlayListStates {
  AddNoteSuccessState(this.message);

  final String? message;
}

class AddNoteFailureState extends PlayListStates {
  AddNoteFailureState(this.message);
  final String? message;
}
