class PackagesModel {
  int? status;
  String? message;
  List<Data>? data;

  PackagesModel({this.status, this.message, this.data});

  PackagesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

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

class Data {
  int? id;
  bool? isExtra;
  bool? monthly;
  String? name;
  int? price;
  int? isSubscribed;
  List<Features>? features;

  Data({this.id, this.isExtra,this.monthly, this.name, this.price,this.isSubscribed, this.features});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isExtra = json['is_extra'];
    monthly = json['monthly'];
    name = json['name'];
    price = json['price'];
    isSubscribed = json['is_subscribed'];
    if (json['features'] != null) {
      features = <Features>[];
      json['features'].forEach((v) {
        features!.add(Features.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['is_extra'] = isExtra;
    data['monthly'] = monthly;
    data['name'] = name;
    data['price'] = price;
    data['is_subscribed'] = isSubscribed;
    if (features != null) {
      data['features'] = features!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Features {
  int? id;
  String? name;

  Features({this.id, this.name});

  Features.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}