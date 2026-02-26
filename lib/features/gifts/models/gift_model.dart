class InvoicesResponseModel {
  InvoicesResponseModel({required this.success, required this.data, this.meta});

  factory InvoicesResponseModel.fromJson(Map<String, dynamic> json) {
    return InvoicesResponseModel(
      success: json['success'] ?? false,
      data: json['data'] != null
          ? List<InvoiceModel>.from(
              json['data'].map((e) => InvoiceModel.fromJson(e)),
            )
          : [],
      meta: json['meta'] != null ? MetaModel.fromJson(json['meta']) : null,
    );
  }
  final bool success;
  final List<InvoiceModel> data;
  final MetaModel? meta;
}

class InvoiceModel {
  InvoiceModel({
    required this.id,
    required this.invoiceNumber,
    required this.userId,
    required this.offerId,
    required this.createdBy,
    required this.createdByType,
    required this.createdByName,
    required this.invoiceType,
    required this.status,
    required this.paymentWay,
    required this.payments,
    required this.deductedPoints,
    this.code,
    required this.pointsDiscount,
    required this.codeDiscount,
    required this.residual,
    required this.qBank,
    required this.isQBank,
    required this.isUnlimited,
    this.expiredAt,
    this.paymentID,
    this.trackID,
    this.receiptId,
    required this.active,
    required this.paymentStatus,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.offer,
  });

  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    return InvoiceModel(
      id: json['id'] ?? 0,
      invoiceNumber: json['invoice_number'] ?? '',
      userId: json['user_id'] ?? 0,
      offerId: json['offer_id'] ?? 0,
      createdBy: json['created_by'] ?? 0,
      createdByType: json['created_by_type'] ?? '',
      createdByName: json['created_by_name'] ?? '',
      invoiceType: json['invoice_type'] ?? '',
      status: json['status'] ?? '',
      paymentWay: json['payment_way'] ?? '',
      payments: json['payments'] ?? '',
      deductedPoints: json['deducted_points'] ?? 0,
      code: json['code'],
      pointsDiscount: json['points_discount'] ?? '0',
      codeDiscount: json['code_discount'] ?? '0',
      residual: json['residual'] ?? 0,
      qBank: json['q_bank'] ?? 0,
      isQBank: json['is_q_bank'] ?? 0,
      isUnlimited: json['is_unlimited'] ?? 0,
      expiredAt: json['expired_at'] != null
          ? DateTime.tryParse(json['expired_at'])
          : null,
      paymentID: json['PaymentID'],
      trackID: json['TrackID'],
      receiptId: json['receipt_id'],
      active: json['active'] ?? false,
      paymentStatus: json['payment_status'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
      user: json['user'] != null
          ? InvoiceUserModel.fromJson(json['user'])
          : null,
      offer: json['offer'] != null ? OfferModel.fromJson(json['offer']) : null,
    );
  }
  final int id;
  final String invoiceNumber;
  final int userId;
  final int offerId;
  final int createdBy;
  final String createdByType;
  final String createdByName;
  final String invoiceType;
  final String status;
  final String paymentWay;
  final String payments;
  final int deductedPoints;
  final String? code;
  final String pointsDiscount;
  final String codeDiscount;
  final int residual;
  final int qBank;
  final int isQBank;
  final int isUnlimited;
  final DateTime? expiredAt;
  final String? paymentID;
  final String? trackID;
  final String? receiptId;
  final bool active;
  final String paymentStatus;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  final InvoiceUserModel? user;
  final OfferModel? offer;
}

class InvoiceUserModel {
  InvoiceUserModel({
    required this.id,
    required this.name,
    this.code,
    required this.email,
    this.googleId,
    this.appleId,
    required this.role,
    required this.points,
    this.fcmToken,
    this.token,
    this.emailVerifiedAt,
    this.qBankQesNo,
    this.createdAt,
    this.updatedAt,
  });

  factory InvoiceUserModel.fromJson(Map<String, dynamic> json) {
    return InvoiceUserModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      code: json['code'],
      email: json['email'] ?? '',
      googleId: json['google_id'],
      appleId: json['apple_id'],
      role: json['role'] ?? '',
      points: json['points'] ?? 0,
      fcmToken: json['fcm_token'],
      token: json['token'],
      emailVerifiedAt: json['email_verified_at'] != null
          ? DateTime.tryParse(json['email_verified_at'])
          : null,
      qBankQesNo: json['q_bank_qes_no'],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }
  final int id;
  final String name;
  final String? code;
  final String email;
  final String? googleId;
  final String? appleId;
  final String role;
  final int points;
  final String? fcmToken;
  final String? token;
  final DateTime? emailVerifiedAt;
  final String? qBankQesNo;
  final DateTime? createdAt;
  final DateTime? updatedAt;
}

class OfferModel {
  OfferModel({
    required this.id,
    required this.name,
    required this.priceBeforeDiscount,
    required this.price,
    required this.months,
    required this.times,
    required this.isTimes,
    required this.qBank,
    required this.isExtra,
    required this.isMain,
    required this.isAdmin,
    required this.isUnlimited,
    this.createdAt,
    this.updatedAt,
  });

  factory OfferModel.fromJson(Map<String, dynamic> json) {
    return OfferModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      priceBeforeDiscount: json['price_before_discount'] ?? '0',
      price: json['price'] ?? 0,
      months: json['months'] ?? '0',
      times: json['times'] ?? 0,
      isTimes: json['is_times'] ?? false,
      qBank: json['q_bank'] ?? false,
      isExtra: json['is_extra'] ?? false,
      isMain: json['is_main'] ?? false,
      isAdmin: json['is_admin'] ?? false,
      isUnlimited: json['is_unlimited'] ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }
  final int id;
  final String name;
  final String priceBeforeDiscount;
  final int price;
  final String months;
  final int times;
  final bool isTimes;
  final bool qBank;
  final bool isExtra;
  final bool isMain;
  final bool isAdmin;
  final bool isUnlimited;
  final DateTime? createdAt;
  final DateTime? updatedAt;
}

class MetaModel {
  MetaModel({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory MetaModel.fromJson(Map<String, dynamic> json) {
    return MetaModel(
      currentPage: json['current_page'] ?? 0,
      lastPage: json['last_page'] ?? 0,
      perPage: json['per_page'] ?? 0,
      total: json['total'] ?? 0,
    );
  }
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;
}
