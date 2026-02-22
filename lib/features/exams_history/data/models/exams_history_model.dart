import 'package:smle/features/analysis/data/model/analysis_model.dart'; // تأكد من مسار Analysis

class ExamsHistoryModel {
  ExamsHistoryModel({this.status, this.message, this.data});

  ExamsHistoryModel.fromJson(Map<String, dynamic> json) {
    // جعلنا status يقبل bool أو int بناءً على الـ JSON الجديد
    status = json['status'] == true
        ? 1
        : (json['status'] == false ? 0 : json['status']);
    message = json['message'];
    if (json['data'] != null) {
      data = <Exam>[];
      json['data'].forEach((v) {
        data!.add(Exam.fromJson(v));
      });
    }
  }

  dynamic status;
  String? message;
  List<Exam>? data;
}

class Exam {
  Exam.fromJson(Map<String, dynamic> json) {
    examId = json['exam_id'];
    score = json['total_score']; // المفتاح الجديد من الـ JSON
    examDate = json['exam_date'];

    if (json['categories'] != null) {
      categories = <Analysis>[];
      json['categories'].forEach((v) {
        categories!.add(Analysis.fromJson(v));
      });
    }
  }
  Exam({this.examId, this.score, this.examDate, this.categories});

  // Getter لربط الموديل القديم بالجديد دون كسر الـ UI
  int? get examNo => examId;

  int? examId;
  num? score;
  String? examDate;
  List<Analysis>? categories;
}
