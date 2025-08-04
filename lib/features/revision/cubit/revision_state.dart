part of 'revision_cubit.dart';

abstract class RevisionStates {}

class RevisionInitialState extends RevisionStates {}

/// Get Categories
class GetCategoriesLoadingState extends RevisionStates {}
class GetCategoriesSuccessState extends RevisionStates {}
class GetCategoriesFailedState extends RevisionStates {}

/// Get Sub Categories
class GetSubCategoriesLoadingState extends RevisionStates {}
class GetSubCategoriesSuccessState extends RevisionStates {}
class GetSubCategoriesFailedState extends RevisionStates {}
