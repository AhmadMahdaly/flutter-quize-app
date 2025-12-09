import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:smle/core/theme/colors.dart';

void configLoading(BuildContext context) {
  EasyLoading.instance
    ..loadingStyle = EasyLoadingStyle.custom
    ..backgroundColor = AppColors.secondaryColor
    ..indicatorColor = Theme.of(context).primaryColor
    ..textColor = Theme.of(context).primaryColor
    ..maskColor = AppColors.forthColor
    ..dismissOnTap = false
    ..maskType = EasyLoadingMaskType.black
    ..userInteractions = false;
}
