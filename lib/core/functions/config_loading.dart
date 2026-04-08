import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:smle/core/theme/colors.dart';

void configLoading(BuildContext context) {
  EasyLoading.instance
    ..loadingStyle = EasyLoadingStyle.custom
    ..backgroundColor = AppColors.secondaryColor
    ..indicatorColor = Theme.of(context).secondaryHeaderColor
    ..textColor = Theme.of(context).secondaryHeaderColor
    ..maskColor = AppColors.secondaryColor
    ..dismissOnTap = false
    ..maskType = EasyLoadingMaskType.black
    ..userInteractions = false;
}
