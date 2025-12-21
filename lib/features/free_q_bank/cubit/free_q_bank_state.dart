part of 'free_q_bank_cubit.dart';

abstract class FreeQBankStates {}

class QBankInitialState extends FreeQBankStates {}

class StartQuizLoadingState extends FreeQBankStates {}

class StartQuizSuccessState extends FreeQBankStates {}

class StartQuizFailedState extends FreeQBankStates {}

class SetIndexQuizState extends FreeQBankStates {}

class QuizModelSetState extends FreeQBankStates {}

class GetCategoriesLoadingState extends FreeQBankStates {}

class GetCategoriesSuccessState extends FreeQBankStates {}

class GetCategoriesFailedState extends FreeQBankStates {}

class GetSubCategoriesLoadingState extends FreeQBankStates {}

class GetSubCategoriesSuccessState extends FreeQBankStates {}

class GetSubCategoriesFailedState extends FreeQBankStates {}

class GetQuestionsCountLoadingState extends FreeQBankStates {}

class GetQuestionsCountSuccessState extends FreeQBankStates {}

class GetQuestionsCountFailedState extends FreeQBankStates {}

class SelectDateState extends FreeQBankStates {}

class FilterChangedState extends FreeQBankStates {}

class SelectCategoryState extends FreeQBankStates {}

class SelectSubCategoryState extends FreeQBankStates {}

class SelectAnswerState extends FreeQBankStates {}

class MarkingAsAnsweredState extends FreeQBankStates {}

class MarkAsAnsweredSuccessState extends FreeQBankStates {}

class MarkAsAnsweredFailedState extends FreeQBankStates {}

class SetIsAnsweredState extends FreeQBankStates {}

class GetPlaylistQuestionsLoadingState extends FreeQBankStates {}

class GetPlaylistQuestionsSuccessState extends FreeQBankStates {}

class GetPlaylistQuestionsFailedState extends FreeQBankStates {}

class PlaylistQuestionsEndState extends FreeQBankStates {}

class AddNoteLoadingState extends FreeQBankStates {}

class AddNoteSuccessState extends FreeQBankStates {
  AddNoteSuccessState(this.message);
  final String message;
}

class AddNoteFailureState extends FreeQBankStates {
  AddNoteFailureState(this.error);
  final String error;
}
