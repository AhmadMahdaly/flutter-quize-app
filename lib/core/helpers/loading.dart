import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:smle/core/helpers/app_localization.dart';

import '../constants.dart';

void showLoading(){
  EasyLoading.show(
          status: 'loading'.tr(navigatorKey.currentContext!),
        );
}
void hideLoading(){
  EasyLoading.dismiss();
}