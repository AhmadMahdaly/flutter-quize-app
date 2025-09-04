class QuestionCountModel {
  QuestionCountModel({this.count, this.success});

  QuestionCountModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    success = json['success'];
  }
  int? count;
  bool? success;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    data['success'] = success;
    return data;
  }
}
