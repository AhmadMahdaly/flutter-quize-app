import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/shared_widgets/custom_app_bar.dart';
import 'package:smle/core/shared_widgets/no_data_widget.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';
import 'package:smle/features/leader_board/data/models/leaderboard_model.dart';
import 'package:smle/features/leader_board/presentation/controllers/cubit/leaderboard_cubit.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Leaderboard'),
      body: BlocBuilder<LeaderboardCubit, LeaderboardState>(
        builder: (context, state) {
          if (state is LeaderboardLoading) {
            return const LoadingWidget();
          } else if (state is LeaderboardError) {
            return Center(child: Text(state.message));
          } else if (state is LeaderboardLoaded) {
            final leaderboard = state.data.leaderboard;

            if (leaderboard.isEmpty) {
              return const Center(child: Text('No competitors yet.'));
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: leaderboard.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final user = leaderboard[index];
                      final isCurrentUser =
                          user.rank == state.data.currentUserRank;
                      return _buildLeaderboardTile(
                        user,
                        isCurrentUser: isCurrentUser,
                      );
                    },
                  ),
                ),
                if (state.data.currentUserRank != null &&
                    state.data.currentUserBest != null)
                  _buildCurrentUserBottomBar(
                    rank: state.data.currentUserRank!,
                    best: state.data.currentUserBest!,
                  ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildCurrentUserBottomBar({
    required int rank,
    required CurrentUserBest best,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColors.iconColorBlack,
            AppColors.iconColorGray,
            AppColors.primaryDColor,
          ],
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDColor.withAlpha(77),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Best Result',
                  style: TextStyle(fontSize: 12, color: Colors.white70),
                ),
                Text(
                  '${best.score.toStringAsFixed(2)} Points',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.amber,
                  ),
                ),
                Text(
                  'Test: ${best.examNo}',
                  style: const TextStyle(fontSize: 12, color: Colors.white70),
                ),
              ],
            ),

            Row(
              children: [
                const Text(
                  'Your Current Rank',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                12.horizontalSpace,
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Text(
                    '#$rank',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade900,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaderboardTile(
    LeaderboardEntry user, {
    bool isCurrentUser = false,
  }) {
    Color rankColor;
    IconData? rankIcon;

    switch (user.rank) {
      case 1:
        rankColor = Colors.amber;
        rankIcon = Icons.emoji_events;
        break;
      case 2:
        rankColor = Colors.grey.shade400;
        rankIcon = Icons.military_tech;
        break;
      case 3:
        rankColor = Colors.brown.shade300;
        rankIcon = Icons.military_tech;
        break;
      default:
        rankColor = Colors.blueGrey.shade100;
        rankIcon = null;
    }

    return Card(
      color: Colors.white,
      elevation: isCurrentUser ? 4 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),

        side: isCurrentUser
            ? const BorderSide(color: AppColors.primaryColor, width: 6)
            : BorderSide.none,
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: rankColor,
          child: rankIcon != null
              ? Icon(rankIcon, color: Colors.white)
              : Text(
                  '${user.rank}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
        ),
        title: Text(
          user.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,

            color: isCurrentUser ? AppColors.primaryDColor : Colors.black,
          ),
        ),
        subtitle: Text(
          'Attempts: ${user.attempts} | Percentage: ${user.percentage.toStringAsFixed(1)}%',
          style: AppTextStyle.style9W600.copyWith(
            color: AppColors.darkGreyColor,
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Points',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            Text(
              user.score.toStringAsFixed(2),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
