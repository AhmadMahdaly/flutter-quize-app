class FinishAnalysisExamModel {
  FinishAnalysisExamModel({
    required this.status,
    required this.message,
    required this.totalScore,
    required this.data,
  });

  factory FinishAnalysisExamModel.fromJson(Map<String, dynamic> json) {
    return FinishAnalysisExamModel(
      status: json['status'],
      message: json['message'],
      totalScore: (json['total_score'] as num).toDouble(),
      data: (json['data'] as List)
          .map((item) => ScoreData.fromJson(item))
          .toList(),
    );
  }
  final int status;
  final String message;
  final double totalScore;
  final List<ScoreData> data;

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'total_score': totalScore,
      'data': data.map((item) => item.toJson()).toList(),
    };
  }
}

class ScoreData {
  ScoreData({
    required this.category,
    required this.averagePercentage,
    required this.examPercentage,
  });

  factory ScoreData.fromJson(Map<String, dynamic> json) {
    return ScoreData(
      category: json['category'],
      averagePercentage: json['average_percentage'],
      examPercentage: (json['exam_percentage'] as num).toDouble(),
    );
  }
  final String category;
  final int averagePercentage;
  final double examPercentage;

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'average_percentage': averagePercentage,
      'exam_percentage': examPercentage,
    };
  }
}
