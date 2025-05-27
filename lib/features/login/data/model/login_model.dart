class LoginModel {
  int? status;
  String? message;
  Data? data;

  LoginModel({this.status, this.message, this.data});

  LoginModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

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
  int? id;
  String? name;
  String? code;
  String? email;
  String? googleId;
  String? appleId;
  String? role;
  int? points;
  String? fcmToken;
  String? token;
  String? emailVerifiedAt;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.id,
        this.name,
        this.code,
        this.email,
        this.googleId,
        this.appleId,
        this.role,
        this.points,
        this.fcmToken,
        this.token,
        this.emailVerifiedAt,
        this.createdAt,
        this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    email = json['email'];
    googleId = json['google_id'];
    appleId = json['apple_id'];
    role = json['role'];
    points = json['points'];
    fcmToken = json['fcm_token'];
    token = json['token'];
    emailVerifiedAt = json['email_verified_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['code'] = code;
    data['email'] = email;
    data['google_id'] = googleId;
    data['apple_id'] = appleId;
    data['role'] = role;
    data['points'] = points;
    data['fcm_token'] = fcmToken;
    data['token'] = token;
    data['email_verified_at'] = emailVerifiedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}