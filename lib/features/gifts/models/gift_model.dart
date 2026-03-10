class InvoicesResponseModel {
  InvoicesResponseModel({required this.success, required this.data, this.meta});

  factory InvoicesResponseModel.fromJson(Map<String, dynamic> json) {
    return InvoicesResponseModel(
      success: parseBool(json['success']),
      data:
          (json['data'] as List?)
              ?.map((e) => InvoiceModel.fromJson(e))
              .toList() ??
          [],
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
      id: parseInt(json['id']),
      invoiceNumber: parseString(json['invoice_number']),
      userId: parseInt(json['user_id']),
      offerId: parseInt(json['offer_id']),
      createdBy: parseInt(json['created_by']),
      createdByType: parseString(json['created_by_type']),
      createdByName: parseString(json['created_by_name']),
      invoiceType: parseString(json['invoice_type']),
      status: parseString(json['status']),
      paymentWay: parseString(json['payment_way']),
      payments: parseString(json['payments']),
      deductedPoints: parseInt(json['deducted_points']),
      code: json['code']?.toString(),
      pointsDiscount: parseString(json['points_discount']),
      codeDiscount: parseString(json['code_discount']),
      residual: parseInt(json['residual']),
      qBank: parseInt(json['q_bank']),
      isQBank: parseInt(json['is_q_bank']),
      isUnlimited: parseInt(json['is_unlimited']),
      expiredAt: parseDate(json['expired_at']),
      paymentID: json['PaymentID']?.toString(),
      trackID: json['TrackID']?.toString(),
      receiptId: json['receipt_id']?.toString(),
      active: parseBool(json['active']),
      paymentStatus: parseString(json['payment_status']),
      createdAt: parseDate(json['created_at']),
      updatedAt: parseDate(json['updated_at']),
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
    this.months,
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
      id: parseInt(json['id']),
      name: parseString(json['name']),
      priceBeforeDiscount: parseString(json['price_before_discount']),
      price: parseDouble(json['price']),
      months: json['months']?.toString(),
      times: parseInt(json['times']),
      isTimes: parseBool(json['is_times']),
      qBank: parseBool(json['q_bank']),
      isExtra: parseBool(json['is_extra']),
      isMain: parseBool(json['is_main']),
      isAdmin: parseBool(json['is_admin']),
      isUnlimited: parseBool(json['is_unlimited']),
      createdAt: parseDate(json['created_at']),
      updatedAt: parseDate(json['updated_at']),
    );
  }

  final int id;
  final String name;
  final String priceBeforeDiscount;
  final double price;
  final String? months;
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

///
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
