class ExamsHistoryModel {
  ExamsHistoryModel({this.status, this.message, this.data});

  ExamsHistoryModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Exam>[];
      json['data'].forEach((v) {
        data!.add(Exam.fromJson(v));
      });
    }
  }
  int? status;
  String? message;
  List<Exam>? data;
}

class Exam {
  Exam({this.id, this.examNo, this.score});

  Exam.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    examNo = json['exam_no'];
    score = json['score'];
  }
  int? id;
  int? examNo;
  num? score;
}
