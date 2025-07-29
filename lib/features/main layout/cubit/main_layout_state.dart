part of 'main_layout_cubit.dart';

abstract class MainLayoutState extends Equatable {
  const MainLayoutState();

  @override
  List<Object> get props => [];
}

class MainLayoutInitial extends MainLayoutState {}

class AppBottomNavState extends MainLayoutState {
  final int currentIndex;

  const AppBottomNavState(this.currentIndex);

  @override
  List<Object> get props => [currentIndex];
}

/// Get Profile
class GetProfileLoadingState extends MainLayoutState {}
class GetProfileSuccessState extends MainLayoutState {}
class GetProfileFailedState extends MainLayoutState {}

/// Delete Account
class DeleteAccountLoadingState extends MainLayoutState {}
class DeleteAccountSuccessState extends MainLayoutState {}
class DeleteAccountFailedState extends MainLayoutState {}