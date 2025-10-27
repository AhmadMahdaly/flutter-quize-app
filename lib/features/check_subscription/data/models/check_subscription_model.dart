class CheckSubscriptionModel {

  CheckSubscriptionModel({
    this.isSubscribed,
    this.qBank,
    this.availableRealExam,
    this.expireDate,
  });

  factory CheckSubscriptionModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return CheckSubscriptionModel(); // 👈 مهم جدًا

    return CheckSubscriptionModel(
      isSubscribed: json['is_subscribed'] as bool?,
      qBank: json['q_bank'] as bool?,
      availableRealExam: json['available_real_exam'] as String?,
      expireDate: json['expire_date'] as String?,
    );
  }
  final bool? isSubscribed;
  final bool? qBank;
  final String? availableRealExam;
  final String? expireDate;
}
