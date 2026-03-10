class CheckoutModel {
  CheckoutModel({this.status, this.message, this.data});

  factory CheckoutModel.fromJson(Map<String, dynamic> json) {
    return CheckoutModel(
      status: parseInt(json['status']),
      message: parseString(json['message']),
      data: json['data'] != null ? CheckoutData.fromJson(json['data']) : null,
    );
  }

  int? status;
  String? message;
  CheckoutData? data;
}

class CheckoutData {
  CheckoutData({
    this.offerId,
    this.priceBeforeDiscount,
    this.offerPrice,
    this.codeDiscount,
    this.codeDiscountPrice,
    this.totalAfterCodeDiscount,
    this.deductedPoints,
    this.pointsDiscount,
    this.payments,
  });

  factory CheckoutData.fromJson(Map<String, dynamic> json) {
    return CheckoutData(
      offerId: parseInt(json['offer_id']),
      priceBeforeDiscount: parseString(json['price_before_discount']),
      offerPrice: parseInt(json['offer_price']),
      codeDiscount: parseString(json['code_discount']),
      codeDiscountPrice: parseDouble(json['code_discount_price']),
      totalAfterCodeDiscount: parseDouble(json['total_after_code_discount']),
      deductedPoints: parseInt(json['deducted_points']),
      pointsDiscount: parseInt(json['points_discount']),
      payments: parseDouble(json['payments']),
    );
  }

  int? offerId;
  String? priceBeforeDiscount;
  int? offerPrice;
  String? codeDiscount;
  double? codeDiscountPrice;
  double? totalAfterCodeDiscount;
  int? deductedPoints;
  int? pointsDiscount;
  double? payments;
}

int parseInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is double) return value.toInt();
  return int.tryParse(value.toString()) ?? 0;
}

double parseDouble(dynamic value) {
  if (value == null) return 0;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  return double.tryParse(value.toString()) ?? 0;
}

String parseString(dynamic value) {
  if (value == null) return '';
  return value.toString();
}

bool parseBool(dynamic value) {
  if (value == null) return false;
  if (value is bool) return value;
  if (value is int) return value == 1;
  if (value is String) {
    return value == '1' || value.toLowerCase() == 'true';
  }
  return false;
}

DateTime? parseDate(dynamic value) {
  if (value == null) return null;
  return DateTime.tryParse(value.toString());
}
