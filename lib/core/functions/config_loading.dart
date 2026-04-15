import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void configLoading(BuildContext context) {
  final theme = Theme.of(context);

  EasyLoading.instance
    ..loadingStyle = EasyLoadingStyle.custom
    ..backgroundColor = theme.colorScheme.onPrimary
    ..indicatorColor = theme.colorScheme.primary
    ..textColor = Theme.of(context).secondaryHeaderColor
    ..maskColor = theme.colorScheme.secondary
    ..dismissOnTap = false
    ..maskType = EasyLoadingMaskType.black
    ..userInteractions = false;
}
