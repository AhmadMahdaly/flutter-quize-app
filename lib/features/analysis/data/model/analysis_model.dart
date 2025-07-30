class AnalysisModel {
  AnalysisModel({this.status, this.message, this.totalScore, this.data});

  AnalysisModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    totalScore = json['total_score'];
    if (json['data'] != null) {
      data = <Analysis>[];
      json['data'].forEach((v) {
        data!.add(Analysis.fromJson(v));
      });
    }
  }
  int? status;
  String? message;
  int? totalScore;
  List<Analysis>? data;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['total_score'] = totalScore;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Analysis {
  Analysis({this.category, this.averagePercentage, this.examPercentage});

  Analysis.fromJson(Map<String, dynamic> json) {
    category = json['category'];
    averagePercentage = (json['average_percentage'] as num).toDouble();
    examPercentage = (json['exam_percentage'] as num).toDouble();
  }
  String? category;
  double? averagePercentage;
  double? examPercentage;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['category'] = category;
    data['average_percentage'] = averagePercentage;
    data['exam_percentage'] = examPercentage;
    return data;
  }
}
