class CalculatorInfoModel {

  CalculatorInfoModel(
      {this.status,
        this.message,
        this.realExamScore,
        this.gPA,
        this.cVChecklist});

  CalculatorInfoModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    realExamScore = json['real_exam_score'] != null
        ? RealExamScore.fromJson(json['real_exam_score'])
        : null;
    gPA = json['GPA'] != null ? RealExamScore.fromJson(json['GPA']) : null;
    cVChecklist = json['CV_checklist'] != null
        ? CVChecklist.fromJson(json['CV_checklist'])
        : null;
  }
  int? status;
  String? message;
  RealExamScore? realExamScore;
  RealExamScore? gPA;
  CVChecklist? cVChecklist;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (realExamScore != null) {
      data['real_exam_score'] = realExamScore!.toJson();
    }
    if (gPA != null) {
      data['GPA'] = gPA!.toJson();
    }
    if (cVChecklist != null) {
      data['CV_checklist'] = cVChecklist!.toJson();
    }
    return data;
  }
}

class RealExamScore {

  RealExamScore({this.name, this.key, this.percentage, this.maxScore});

  RealExamScore.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    key = json['key'];
    percentage = json['percentage'];
    maxScore = json['max_score'];
  }
  String? name;
  String? key;
  String? percentage;
  int? maxScore;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['key'] = key;
    data['percentage'] = percentage;
    data['max_score'] = maxScore;
    return data;
  }
}

class CVChecklist {

  CVChecklist({this.name, this.key, this.percentage, this.items});

  CVChecklist.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    key = json['key'];
    percentage = json['percentage'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(Items.fromJson(v));
      });
    }
  }
  String? name;
  String? key;
  String? percentage;
  List<Items>? items;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['key'] = key;
    data['percentage'] = percentage;
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {

  Items({this.id, this.name, this.maxScore});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    maxScore = json['max_score'];
  }
  int? id;
  String? name;
  int? maxScore;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['max_score'] = maxScore;
    return data;
  }
}