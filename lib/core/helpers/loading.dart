import 'package:flutter_easyloading/flutter_easyloading.dart';

void showLoading() {
  EasyLoading.show(status: 'Loading...');
}

void hideLoading() {
  EasyLoading.dismiss();
}
