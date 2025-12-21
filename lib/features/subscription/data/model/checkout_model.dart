class CheckoutModel {
  CheckoutModel({this.status, this.message, this.data});

  CheckoutModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? CheckoutData.fromJson(json['data']) : null;
  }
  int? status;
  String? message;
  CheckoutData? data;
}

class CheckoutData {
  CheckoutData({
    this.offerId,
    this.offerPrice,
    this.codeDiscount,
    this.codeDiscountPrice,
    this.totalAfterCodeDiscount,
    this.deductedPoints,
    this.pointsDiscount,
    this.payments,
  });

  CheckoutData.fromJson(Map<String, dynamic> json) {
    offerId = json['offer_id'];
    offerPrice = json['offer_price'];
    codeDiscount = json['code_discount'];
    codeDiscountPrice = json['code_discount_price'];
    totalAfterCodeDiscount = json['total_after_code_discount'];
    deductedPoints = json['deducted_points'];
    pointsDiscount = json['points_discount'];
    payments = json['payments'];
  }
  int? offerId;
  int? offerPrice;
  String? codeDiscount;
  int? codeDiscountPrice;
  int? totalAfterCodeDiscount;
  int? deductedPoints;
  int? pointsDiscount;
  int? payments;
}
