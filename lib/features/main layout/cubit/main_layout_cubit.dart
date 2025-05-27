import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smle/core/helpers/loading.dart';
import 'package:smle/features/main%20layout/data/model/profile_model.dart';
import '../../../core/constants.dart';
import '../data/repo/main_layout_repo.dart';
part 'main_layout_state.dart';

class MainLayoutCubit extends Cubit<MainLayoutState> {
  MainLayoutCubit(this._mainLayoutRepository) : super(MainLayoutInitial());
  static MainLayoutCubit get(context) => BlocProvider.of(context);
  final MainLayoutRepository _mainLayoutRepository;

  void changeBottomNavBar(index) {
    mainLayoutIntitalScreenIndex = index;
    emit(AppBottomNavState(mainLayoutIntitalScreenIndex));
  }
  /// Get Profile
  ProfileModel? profileModel;
  Future getProfile() async {
    showLoading();
    emit(GetProfileLoadingState());
    final result = await _mainLayoutRepository.getProfile();
    result.when(success: (success) {
      profileModel = success;
      hideLoading();
      emit(GetProfileSuccessState());
    }, failure: (error) {
      hideLoading();
      emit(GetProfileFailedState());
    });
  }

}
