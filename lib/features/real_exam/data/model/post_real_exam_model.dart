class PostRealExamModel {
  PostRealExamModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory PostRealExamModel.fromJson(Map<String, dynamic> json) =>
      PostRealExamModel(
        status: json['status'],
        message: json['message'],
        data: List<Answer>.from(json['data'].map((x) => Answer.fromJson(x))),
      );
  final int status;
  final String message;
  final List<Answer> data;

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Answer {
  Answer({
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
    required this.realAnswer,
    required this.correct,
    this.photo,
    this.notes,
    this.userAnswer,
  });

  factory Answer.fromJson(Map<String, dynamic> json) => Answer(
        id: json['id'],
        examId: json['exam_id'],
        section: json['section'],
        questionNo: json['question_no'],
        questionText: json['question_text'],
        photo: json['photo'],
        a: json['a'],
        b: json['b'],
        c: json['c'],
        d: json['d'],
        isBookmarked: json['is_bookmarked'],
        notes: json['notes'],
        isAnswered: json['is_answered'],
        userAnswer: json['user_answer'],
        realAnswer: json['real_answer'],
        correct: json['correct'],
      );
  final int id;
  final int examId;
  final int section;
  final int questionNo;
  final String questionText;
  final String? photo;
  final String a;
  final String b;
  final String c;
  final String d;
  final bool isBookmarked;
  final String? notes;
  final bool isAnswered;
  final String? userAnswer;
  final String realAnswer;
  final bool correct;

  Map<String, dynamic> toJson() => {
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
        'real_answer': realAnswer,
        'correct': correct,
      };
}
