class PackagesModel {
  PackagesModel({this.status, this.message, this.data});

  factory PackagesModel.fromJson(Map<String, dynamic> json) {
    return PackagesModel(
      status: parseInt(json['status']),
      message: parseString(json['message']),
      data:
          (json['data'] as List?)?.map((e) => Data.fromJson(e)).toList() ?? [],
    );
  }

  int? status;
  String? message;
  List<Data>? data;

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data?.map((e) => e.toJson()).toList(),
    };
  }
}

class Data {
  Data({
    this.id,
    this.isExtra,
    this.monthly,
    this.months,
    this.monthsDuration,
    this.name,
    this.price,
    this.priceBeforeDiscount,
    this.isSubscribed,
    this.appleProductId,
    this.features,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: parseInt(json['id']),
      isExtra: parseBool(json['is_extra']),
      monthly: parseBool(json['monthly']),
      months: json['months']?.toString(),
      monthsDuration: json['months_duration']?.toString(),
      name: parseString(json['name']),
      price: parseDouble(json['price']),
      priceBeforeDiscount: parseDouble(json['price_before_discount']),
      isSubscribed: parseInt(json['is_subscribed']),
      appleProductId: json['apple_product_id']?.toString(),
      features:
          (json['features'] as List?)
              ?.map((e) => Features.fromJson(e))
              .toList() ??
          [],
    );
  }

  int? id;
  bool? isExtra;
  bool? monthly;
  String? months;
  String? monthsDuration;
  String? name;
  double? price;
  double? priceBeforeDiscount;
  int? isSubscribed;
  String? appleProductId;
  List<Features>? features;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'is_extra': isExtra,
      'monthly': monthly,
      'months': months,
      'months_duration': monthsDuration,
      'name': name,
      'price': price,
      'price_before_discount': priceBeforeDiscount,
      'is_subscribed': isSubscribed,
      'apple_product_id': appleProductId,
      'features': features?.map((e) => e.toJson()).toList(),
    };
  }
}

class Features {
  Features({this.id, this.name});

  factory Features.fromJson(Map<String, dynamic> json) {
    return Features(id: parseInt(json['id']), name: parseString(json['name']));
  }

  int? id;
  String? name;

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
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
