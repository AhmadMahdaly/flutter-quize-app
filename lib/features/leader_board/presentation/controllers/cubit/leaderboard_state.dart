part of 'leaderboard_cubit.dart';

abstract class LeaderboardState {}

class LeaderboardInitial extends LeaderboardState {}

class LeaderboardLoading extends LeaderboardState {}

class LeaderboardLoaded extends LeaderboardState {
  LeaderboardLoaded(this.data);
  final LeaderboardData data;
}

class LeaderboardError extends LeaderboardState {
  LeaderboardError(this.message);
  final String message;
}
