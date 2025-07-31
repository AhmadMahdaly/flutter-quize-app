class TrialExamModel {
  TrialExamModel({this.status, this.message, this.data});

  factory TrialExamModel.fromJson(Map<String, dynamic> json) {
    return TrialExamModel(
      status: json['status'],
      message: json['message'],
      data: json['data'] != null
          ? List<TrialQuestion>.from(
              json['data'].map((x) => TrialQuestion.fromJson(x)),
            )
          : null,
    );
  }
  final int? status;
  final String? message;
  final List<TrialQuestion>? data;
}

class TrialQuestion {
  TrialQuestion({
    required this.id,
    required this.question,
    this.photo,
    required this.a,
    required this.b,
    required this.c,
    required this.d,
    required this.answer,
    required this.explanation,
    required this.isFree,
  });

  factory TrialQuestion.fromJson(Map<String, dynamic> json) {
    return TrialQuestion(
      id: json['id'],
      question: json['question'],
      photo: json['photo'],
      a: json['a'],
      b: json['b'],
      c: json['c'],
      d: json['d'],
      answer: json['answer'],
      explanation: json['explanation'],
      isFree: json['is_free'] ?? false,
    );
  }
  final int id;
  final String question;
  final String? photo;
  final String a;
  final String b;
  final String c;
  final String d;
  final String answer;
  final String explanation;
  final bool isFree;
}
