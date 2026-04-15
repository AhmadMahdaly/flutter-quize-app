import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smle/features/leader_board/data/models/leaderboard_model.dart';
import 'package:smle/features/leader_board/data/repo/leaderboard_repo.dart';

part 'leaderboard_state.dart';

class LeaderboardCubit extends Cubit<LeaderboardState> {
  LeaderboardCubit(this._leaderboardRepo) : super(LeaderboardInitial());
  final LeaderboardRepo _leaderboardRepo;

  Future<void> fetchLeaderboard() async {
    emit(LeaderboardLoading());

    final result = await _leaderboardRepo.getLeaderboard();

    result.when(
      success: (response) {
        emit(LeaderboardLoaded(response.data));
      },
      failure: (failure) {
        emit(LeaderboardError(failure.errMessage));
      },
    );
  }
}
