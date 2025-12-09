class PaymentCallbackModel {
  PaymentCallbackModel({
    this.id,
    this.success,
    this.merchantOrderId,
    this.pending,
    this.amountCents,
    this.message,
  });

  factory PaymentCallbackModel.fromJson(Map<String, dynamic> json) {
    return PaymentCallbackModel(
      id: _toInt(json['id']),
      success: _toBool(json['success']),
      merchantOrderId: _toInt(json['merchant_order_id']),
      pending: _toBool(json['pending']),
      amountCents: _toInt(json['amount_cents']),
      message: json['data.message'] ?? json['message'],
    );
  }
  final int? id;
  final bool? success;
  final int? merchantOrderId;
  final bool? pending;
  final int? amountCents;
  final String? message;

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }

  static bool? _toBool(dynamic value) {
    if (value == null) return null;
    if (value is bool) return value;

    final v = value.toString().toLowerCase();
    if (v == 'true' || v == '1') return true;
    if (v == 'false' || v == '0') return false;

    return null;
  }
}
