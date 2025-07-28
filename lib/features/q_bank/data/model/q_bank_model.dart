class QBankModel {

  QBankModel({this.status, this.message, this.data});

  QBankModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }
  int? status;
  String? message;
  List<Data>? data;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
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
    this.categoryId,
    this.subcategoryId,
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
    this.isActive,
    this.hint,
    this.isFree,
    this.isFavourite,
    this.createdAt,
    this.updatedAt,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    question = json['question'];
    photo = json['photo'];
    categoryId = json['category_id'];
    subcategoryId = json['subcategory_id'];
    a = json['a'];
    b = json['b'];
    c = json['c'];
    d = json['d'];
    answer = json['answer'];
    explanation = json['explanation'];
    explanationPhoto = json['explanation_photo'];
    year = json['year'];
    month = json['month'];
    isActive = json['is_active'];
    hint = json['hint'];
    isFree = json['is_free'];
    isFavourite = json['is_favourite'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
  int? id;
  String? question;
  String? photo;
  int? categoryId;
  int? subcategoryId;
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
  bool? isActive;
  String? hint;
  bool? isFree;
  bool? isFavourite;
  String? createdAt;
  String? updatedAt;

  // Getter to return a list of options
  List<Options> get options => [
        Options(key: 'a', value: a ?? ''),
        Options(key: 'b', value: b ?? ''),
        Options(key: 'c', value: c ?? ''),
        Options(key: 'd', value: d ?? '')
      ];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['question'] = question;
    data['photo'] = photo;
    data['category_id'] = categoryId;
    data['subcategory_id'] = subcategoryId;
    data['a'] = a;
    data['b'] = b;
    data['c'] = c;
    data['d'] = d;
    data['options'] = options; // Include list of options
    data['answer'] = answer;
    data['explanation'] = explanation;
    data['explanation_photo'] = explanationPhoto;
    data['year'] = year;
    data['month'] = month;
    data['is_active'] = isActive;
    data['hint'] = hint;
    data['is_free'] = isFree;
    data['is_favourite'] = isFavourite;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Options {

  Options({this.key, this.value});
  String? key;
  String? value;
}
