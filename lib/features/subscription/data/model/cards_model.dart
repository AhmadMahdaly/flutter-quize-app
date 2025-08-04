class CardsModel {

  CardsModel({this.status, this.message, this.data});

  CardsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <CardItem>[];
      json['data'].forEach((v) {
        data!.add(CardItem.fromJson(v));
      });
    }
  }
  int? status;
  String? message;
  List<CardItem>? data;

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

class CardItem {

  CardItem(
      {this.id,
      this.userId,
      this.cardId,
      this.cvv,
      this.password,
      this.expDate,
      this.createdAt,
      this.updatedAt});

  CardItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    cardId = json['card_id'];
    cvv = json['cvv'];
    password = json['password'];
    expDate = json['exp_date'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
  int? id;
  int? userId;
  String? cardId;
  String? cvv;
  String? password;
  String? expDate;
  String? createdAt;
  String? updatedAt;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['card_id'] = cardId;
    data['cvv'] = cvv;
    data['password'] = password;
    data['exp_date'] = expDate;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
