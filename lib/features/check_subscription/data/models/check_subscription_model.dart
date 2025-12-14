class CheckSubscriptionModel {
  CheckSubscriptionModel({
    this.isSubscribed,
    this.qBank,
    this.availableRealExam,
    this.expireDate,
  });

  factory CheckSubscriptionModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return CheckSubscriptionModel();

    return CheckSubscriptionModel(
      isSubscribed: _toBool(json['is_subscribed']),
      qBank: _toBool(json['q_bank']),
      availableRealExam: json['available_real_exam']?.toString(),
      expireDate: json['expire_date'] as String?,
    );
  }

  final bool? isSubscribed;
  final bool? qBank;
  final String? availableRealExam;
  final String? expireDate;

  // -------- Helpers ----------
  // static int? _toInt(dynamic value) {
  //   if (value == null) return null;
  //   if (value is int) return value;
  //   return int.tryParse(value.toString());
  // }

  static bool? _toBool(dynamic value) {
    if (value == null) return null;
    if (value is bool) return value;

    final v = value.toString().toLowerCase();
    if (v == 'true' || v == '1') return true;
    if (v == 'false' || v == '0') return false;

    return null;
  }
}
