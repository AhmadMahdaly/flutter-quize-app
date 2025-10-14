part of 'q_bank_cubit.dart';

abstract class QBankStates {}

class QBankInitialState extends QBankStates {}

class StartQuizLoadingState extends QBankStates {}

class StartQuizSuccessState extends QBankStates {}

class StartQuizFailedState extends QBankStates {}

class SetIndexQuizState extends QBankStates {}

class QuizModelSetState extends QBankStates {}

class GetCategoriesLoadingState extends QBankStates {}

class GetCategoriesSuccessState extends QBankStates {}

class GetCategoriesFailedState extends QBankStates {}

class GetSubCategoriesLoadingState extends QBankStates {}

class GetSubCategoriesSuccessState extends QBankStates {}

class GetSubCategoriesFailedState extends QBankStates {}

class GetQuestionsCountLoadingState extends QBankStates {}

class GetQuestionsCountSuccessState extends QBankStates {}

class GetQuestionsCountFailedState extends QBankStates {}

class SelectDateState extends QBankStates {}

class FilterChangedState extends QBankStates {}

class SelectCategoryState extends QBankStates {}

class SelectSubCategoryState extends QBankStates {}

class SelectAnswerState extends QBankStates {}

class MarkingAsAnsweredState extends QBankStates {}

class MarkAsAnsweredSuccessState extends QBankStates {}

class MarkAsAnsweredFailedState extends QBankStates {}

class SetIsAnsweredState extends QBankStates {}
class GetPlaylistQuestionsLoadingState extends QBankStates {}

class GetPlaylistQuestionsSuccessState extends QBankStates {}

class GetPlaylistQuestionsFailedState extends QBankStates {}

class PlaylistQuestionsEndState extends QBankStates {}