part of 'main_layout_cubit.dart';

abstract class MainLayoutState extends Equatable {
  const MainLayoutState();

  @override
  List<Object> get props => [];
}

class MainLayoutInitial extends MainLayoutState {}

class AppBottomNavState extends MainLayoutState {

  const AppBottomNavState(this.currentIndex);
  final int currentIndex;

  @override
  List<Object> get props => [currentIndex];
}

/// Get Profile
class GetProfileLoadingState extends MainLayoutState {}
class GetProfileSuccessState extends MainLayoutState {}
class GetProfileFailedState extends MainLayoutState {}

/// Get Gifts
class GetGiftsLoadingState extends MainLayoutState {}
class GetGiftsSuccessState extends MainLayoutState {}
class GetGiftsFailedState extends MainLayoutState {}

/// Delete Account
class DeleteAccountLoadingState extends MainLayoutState {}
class DeleteAccountSuccessState extends MainLayoutState {}
class DeleteAccountFailedState extends MainLayoutState {}