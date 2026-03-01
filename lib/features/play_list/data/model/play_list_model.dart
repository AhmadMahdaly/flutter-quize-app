class PlayListModel {
  PlayListModel({this.status, this.message, this.data});

  PlayListModel.fromJson(Map<String, dynamic> json) {
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
  Data({this.id, this.name, this.userId, this.questions});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    userId = json['user_id'];
    if (json['questions'] != null) {
      questions = <Questions>[];
      json['questions'].forEach((v) {
        questions!.add(Questions.fromJson(v));
      });
    }
  }
  int? id;
  String? name;
  int? userId;
  List<Questions>? questions;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['user_id'] = userId;
    if (questions != null) {
      data['questions'] = questions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Questions {
  Questions({this.id});

  Questions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
  }
  int? id;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    return data;
  }
}

class PlaylistQuestionsResponse {
  PlaylistQuestionsResponse({this.status, this.message, this.data});

  PlaylistQuestionsResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? PaginationData.fromJson(json['data']) : null;
  }
  int? status;
  String? message;
  PaginationData? data;
}

class PaginationData {
  PaginationData({this.currentPage, this.data, this.lastPage, this.total});

  PaginationData.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    lastPage = json['last_page'];
    total = json['total'];
    if (json['data'] != null) {
      data = <QuestionItemData>[];
      json['data'].forEach((v) {
        data!.add(QuestionItemData.fromJson(v));
      });
    }
  }
  int? currentPage;
  List<QuestionItemData>? data;
  int? lastPage;
  int? total;
}

class QuestionItemData {
  QuestionItemData.fromJson(Map<String, dynamic> json) {
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
    hint = json['hint'];
    isFavourite = json['is_favourite'] ?? false;
  }
  int? id;
  String? question;
  String? photo;
  String? a;
  String? b;
  String? c;
  String? d;
  String? answer;
  String? explanation;
  String? explanationPhoto;
  String? hint;
  bool? isFavourite;

  // متغير إضافي محلي لحفظ إجابة المستخدم إن أردت
  String? selectedAnswer;

  // هذه الدالة ستقوم بتجميع الخيارات لكي يسهل عرضها في الـ UI كما هي في كودك الحالي
  List<OptionItem> get options {
    final List<OptionItem> list = [];
    if (a != null && a != 'NULL') list.add(OptionItem(key: 'a', value: a));
    if (b != null && b != 'NULL') list.add(OptionItem(key: 'b', value: b));
    if (c != null && c != 'NULL') list.add(OptionItem(key: 'c', value: c));
    if (d != null && d != 'NULL') list.add(OptionItem(key: 'd', value: d));
    return list;
  }
}

class OptionItem {
  OptionItem({required this.key, this.value});
  String key;
  String? value;
}
