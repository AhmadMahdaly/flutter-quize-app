import 'package:smle/features/analysis/domain/entities/analysis.dart';

class AnalysisModel extends Analysis {
  AnalysisModel({
    required this.message,
    required this.totalScore,
    required this.data,
  }) : super(message: message, totalScore: totalScore, data: data);

  factory AnalysisModel.fromJson(Map<String, dynamic> json) => AnalysisModel(
    message: json['message'],
    totalScore: (json['total_score'] as num).toDouble(),
    data: (json['data'] as List)
        .map((e) => AnalysisDataModel.fromJson(e))
        .toList(),
  );

  @override
  final String message;
  @override
  final double totalScore;
  @override
  final List<AnalysisDataModel> data;
}

class AnalysisDataModel extends AnalysisData {
  AnalysisDataModel({
    required this.category,
    required this.averagePercentage,
    required this.examPercentage,
  }) : super(
         category: category,
         averagePercentage: averagePercentage,
         examPercentage: examPercentage,
       );

  factory AnalysisDataModel.fromJson(Map<String, dynamic> json) {
    return AnalysisDataModel(
      category: json['category'],
      averagePercentage: (json['average_percentage'] as num).toDouble(),
      examPercentage: (json['exam_percentage'] as num).toDouble(),
    );
  }
  @override
  final String category;
  @override
  final double averagePercentage;
  @override
  final double examPercentage;
}
