class Analysis {
  Analysis({
    required this.message,
    required this.totalScore,
    required this.data,
  });

  final String message;
  final double totalScore;
  final List<AnalysisData> data;
}

class AnalysisData {
  AnalysisData({
    required this.category,
    required this.averagePercentage,
    required this.examPercentage,
  });

  final String category;
  final double averagePercentage;
  final double examPercentage;
}
