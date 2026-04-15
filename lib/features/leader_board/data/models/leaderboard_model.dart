class LeaderboardResponse {
  LeaderboardResponse({required this.status, required this.data});

  factory LeaderboardResponse.fromJson(Map<String, dynamic> json) {
    return LeaderboardResponse(
      status: json['status'] ?? false,
      data: LeaderboardData.fromJson(json['data'] ?? {}),
    );
  }
  final bool status;
  final LeaderboardData data;
}

class CurrentUserBest {
  CurrentUserBest({
    required this.score,
    required this.percentage,
    required this.createdAt,
    required this.examNo,
  });

  factory CurrentUserBest.fromJson(Map<String, dynamic> json) {
    return CurrentUserBest(
      score: (json['score'] as num?)?.toDouble() ?? 0.0,
      percentage: (json['percentage'] as num?)?.toDouble() ?? 0.0,
      createdAt: json['created_at']?.toString() ?? '',
      examNo: json['exam_no'] ?? 0,
    );
  }
  final double score;
  final double percentage;
  final String createdAt;
  final int examNo;
}

class LeaderboardData {
  LeaderboardData({
    required this.leaderboard,
    this.currentUserRank,
    this.currentUserBest,
  });

  factory LeaderboardData.fromJson(Map<String, dynamic> json) {
    return LeaderboardData(
      leaderboard:
          (json['leaderboard'] as List?)
              ?.map((e) => LeaderboardEntry.fromJson(e))
              .toList() ??
          [],
      currentUserRank: json['current_user_rank'],
      currentUserBest: json['current_user_best'] != null
          ? CurrentUserBest.fromJson(json['current_user_best'])
          : null,
    );
  }
  final List<LeaderboardEntry> leaderboard;
  final int? currentUserRank;
  final CurrentUserBest? currentUserBest;
}

class LeaderboardEntry {
  LeaderboardEntry({
    required this.userId,
    required this.name,
    required this.examId,
    required this.examNo,
    required this.score,
    required this.percentage,
    required this.examDate,
    required this.attempts,
    required this.rank,
  });

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) {
    return LeaderboardEntry(
      userId: json['user_id'] ?? 0,
      name: json['name'] ?? '',
      examId: json['exam_id'] ?? 0,
      examNo: json['exam_no'] ?? 0,

      score: (json['score'] as num?)?.toDouble() ?? 0.0,
      percentage: (json['percentage'] as num?)?.toDouble() ?? 0.0,
      examDate: json['exam_date'] ?? '',
      attempts: json['attempts'] ?? 0,
      rank: json['rank'] ?? 0,
    );
  }
  final int userId;
  final String name;
  final int examId;
  final int examNo;
  final double score;
  final double percentage;
  final String examDate;
  final int attempts;
  final int rank;
}
