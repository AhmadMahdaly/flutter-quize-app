class StartRealExamModel {
  StartRealExamModel({
    required this.status,
    required this.message,
    required this.examId,
    required this.questionsCount,
    required this.data,
  });

  factory StartRealExamModel.fromJson(Map<String, dynamic> json) {
    return StartRealExamModel(
      status: json['status'],
      message: json['message']?.toString(),
      examId: json['exam_id'],
      questionsCount: json['questions_count'],
      data: json['data'] != null
          ? Question.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
  StartRealExamModel copyWith({
    int? status,
    String? message,
    int? examId,
    int? questionsCount,
    Question? data,
  }) {
    return StartRealExamModel(
      status: status ?? this.status,
      message: message ?? this.message,
      examId: examId ?? this.examId,
      questionsCount: questionsCount ?? this.questionsCount,
      data: data ?? this.data,
    );
  }

  final int? status;
  final String? message;
  final int? examId;
  final int? questionsCount;
  final Question? data;

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'exam_id': examId,
      'questions_count': questionsCount,
      'data': data?.toJson(),
    };
  }
}

class Question {
  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      examId: json['exam_id'],
      section: json['section'],
      questionNo: json['question_no'],
      questionText: json['question_text']?.toString(),
      photo: json['photo']?.toString(),
      a: json['a']?.toString(),
      b: json['b']?.toString(),
      c: json['c']?.toString(),
      d: json['d']?.toString(),
      isBookmarked: json['is_bookmarked'] ?? false,
      notes: json['notes']?.toString(),
      isAnswered: json['is_answered'] ?? false,
      userAnswer: json['user_answer']?.toString(),
    );
  }
  Question({
    required this.id,
    required this.examId,
    required this.section,
    required this.questionNo,
    required this.questionText,
    required this.a,
    required this.b,
    required this.c,
    required this.d,
    required this.isBookmarked,
    required this.isAnswered,
    this.photo,
    this.notes,
    this.userAnswer,
  });
  Question copyWith({
    int? id,
    int? examId,
    int? section,
    int? questionNo,
    String? questionText,
    String? photo,
    String? a,
    String? b,
    String? c,
    String? d,
    bool? isBookmarked,
    String? notes,
    bool? isAnswered,
    String? userAnswer,
  }) {
    return Question(
      id: id ?? this.id,
      examId: examId ?? this.examId,
      section: section ?? this.section,
      questionNo: questionNo ?? this.questionNo,
      questionText: questionText ?? this.questionText,
      photo: photo ?? this.photo,
      a: a ?? this.a,
      b: b ?? this.b,
      c: c ?? this.c,
      d: d ?? this.d,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      notes: notes ?? this.notes,
      isAnswered: isAnswered ?? this.isAnswered,
      userAnswer: userAnswer ?? this.userAnswer,
    );
  }

  final int? id;
  final int? examId;
  final int? section;
  final int? questionNo;
  final String? questionText;
  final String? photo;
  final String? a;
  final String? b;
  final String? c;
  final String? d;
  final bool? isBookmarked;
  final String? notes;
  final bool? isAnswered;
  final String? userAnswer;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'exam_id': examId,
      'section': section,
      'question_no': questionNo,
      'question_text': questionText,
      'photo': photo,
      'a': a,
      'b': b,
      'c': c,
      'd': d,
      'is_bookmarked': isBookmarked,
      'notes': notes,
      'is_answered': isAnswered,
      'user_answer': userAnswer,
    };
  }
}
