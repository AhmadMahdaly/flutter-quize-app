part of 'q_bank_cubit.dart';

abstract class QBankStates {}

class QBankInitialState extends QBankStates {}

/// Start Quiz (Q Bank)
class StartQuizLoadingState extends QBankStates {}
class StartQuizSuccessState extends QBankStates {}
class StartQuizFailedState extends QBankStates {}
class SetOffsetQuizState extends QBankStates {}
class SetIndexQuizState extends QBankStates {}

/// Get Categories
class GetCategoriesLoadingState extends QBankStates {}
class GetCategoriesSuccessState extends QBankStates {}
class GetCategoriesFailedState extends QBankStates {}

/// Get Sub Categories
class GetSubCategoriesLoadingState extends QBankStates {}
class GetSubCategoriesSuccessState extends QBankStates {}
class GetSubCategoriesFailedState extends QBankStates {}

/// Select Date
class SelectDateState extends QBankStates {}

/// Select Category
class SelectCategoryState extends QBankStates {}

/// Select SubCategory
class SelectSubCategoryState extends QBankStates {}

/// Select Answer
class SelectAnswerState extends QBankStates {}

/// Set Is Answered
class SetIsAnsweredState extends QBankStates {}