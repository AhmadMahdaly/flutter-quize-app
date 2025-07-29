class CheckoutModel {
  CheckoutModel({this.status, this.message, this.data});

  CheckoutModel.fromJson(Map<String, dynamic> json) {
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
      {this.offerId,
      this.offerPrice,
      this.codeDiscount,
      this.codeDiscountPrice,
      this.totalAfterCodeDiscount,
      this.deductedPoints,
      this.totalAfterPointsDiscount,
      this.payments});

  Data.fromJson(Map<String, dynamic> json) {
    offerId = json['offer_id'];
    offerPrice = json['offer_price'];
    codeDiscount = json['code_discount'];
    codeDiscountPrice = json['code_discount_price'];
    totalAfterCodeDiscount = json['total_after_code_discount'];
    deductedPoints = json['deducted_points'];
    totalAfterPointsDiscount = json['total_after_points_discount'];
    payments = json['payments'];
  }
  int? offerId;
  int? offerPrice;
  String? codeDiscount;
  int? codeDiscountPrice;
  int? totalAfterCodeDiscount;
  int? deductedPoints;
  int? totalAfterPointsDiscount;
  double? payments;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['offer_id'] = offerId;
    data['offer_price'] = offerPrice;
    data['code_discount'] = codeDiscount;
    data['code_discount_price'] = codeDiscountPrice;
    data['total_after_code_discount'] = totalAfterCodeDiscount;
    data['deducted_points'] = deductedPoints;
    data['total_after_points_discount'] = totalAfterPointsDiscount;
    data['payments'] = payments;
    return data;
  }
}
