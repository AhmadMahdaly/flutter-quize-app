class YearsModel {
  YearsModel({this.success, this.data});

  YearsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <YearData>[];
      json['data'].forEach((v) {
        data!.add(YearData.fromJson(v));
      });
    }
  }

  bool? success;
  List<YearData>? data;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class YearData {
  YearData({this.year, this.month});

  YearData.fromJson(Map<String, dynamic> json) {
    // استخدمنا toString() ثم tryParse لضمان قراءة الرقم سواء جاء كـ String أو int
    year = json['year'] != null ? int.tryParse(json['year'].toString()) : null;
    month = json['month'] != null
        ? int.tryParse(json['month'].toString())
        : null;
  }

  int? year;
  int? month;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['year'] = year;
    data['month'] = month;
    return data;
  }
}
