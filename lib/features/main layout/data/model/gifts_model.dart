class GiftsModel {

  GiftsModel({this.status, this.message, this.data});

  GiftsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  int? status;
  String? message;
  Data? data;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {

  Data.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    points = json['points'];
  }

  Data({this.code, this.points});
  String? code;
  int? points;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['points'] = points;
    return data;
  }
}