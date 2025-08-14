class QBankModel {
  QBankModel({this.status, this.message, this.questionsCount, this.data});

  QBankModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];

    questionsCount = json['questions_count'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }
  int? status;
  String? message;
  int? questionsCount;
  List<Data>? data;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['questions_count'] = questionsCount;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  Data({
    this.id,
    this.question,
    this.photo,
    this.a,
    this.b,
    this.c,
    this.d,
    this.answer,
    this.selectedAnswer,
    this.explanation,
    this.explanationPhoto,
    this.year,
    this.month,
    this.hint,
    this.isFavorite,
    this.isAnswered,
    this.questionbankId,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    question = json['question'];
    photo = json['photo'];
    a = json['a'];
    b = json['b'];
    c = json['c'];
    d = json['d'];
    answer = json['answer'];
    explanation = json['explanation'];
    explanationPhoto = json['explanation_photo'];
    year = json['year'];
    month = json['month'];
    hint = json['hint'];
    isFavorite = json['is_favorite'];

    isAnswered = json['is_answered'] == 1;
    questionbankId = json['questionbank_id'];
  }
  int? id;
  String? question;
  String? photo;
  String? a;
  String? b;
  String? c;
  String? d;
  String? answer;
  String? selectedAnswer;
  String? explanation;
  String? explanationPhoto;
  String? year;
  String? month;
  String? hint;
  bool? isFavorite;
  bool? isAnswered;
  int? questionbankId;

  List<Options> get options => [
    Options(key: 'a', value: a ?? ''),
    Options(key: 'b', value: b ?? ''),
    Options(key: 'c', value: c ?? ''),
    Options(key: 'd', value: d ?? ''),
  ];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['question'] = question;
    data['photo'] = photo;
    data['a'] = a;
    data['b'] = b;
    data['c'] = c;
    data['d'] = d;
    data['answer'] = answer;
    data['explanation'] = explanation;
    data['explanation_photo'] = explanationPhoto;
    data['year'] = year;
    data['month'] = month;
    data['hint'] = hint;
    data['is_favorite'] = isFavorite;
    data['is_answered'] = isAnswered;
    data['questionbank_id'] = questionbankId;
    return data;
  }
}

class Options {
  Options({this.key, this.value});
  String? key;
  String? value;
}
