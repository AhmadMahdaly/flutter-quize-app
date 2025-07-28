class ProfileModel {

  ProfileModel({this.status, this.message, this.data});

  ProfileModel.fromJson(Map<String, dynamic> json) {
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

  Data(
      {this.id,
        this.name,
        this.code,
        this.email,
        this.points,
        this.fcmToken,
        this.photo});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    email = json['email'];
    points = json['points'];
    fcmToken = json['fcm_token'];
    photo = json['photo'];
  }
  int? id;
  String? name;
  String? code;
  String? email;
  int? points;
  String? fcmToken;
  String? photo;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['code'] = code;
    data['email'] = email;
    data['points'] = points;
    data['fcm_token'] = fcmToken;
    data['photo'] = photo;
    return data;
  }
}