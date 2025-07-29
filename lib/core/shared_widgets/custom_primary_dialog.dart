import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smle/core/theme/colors.dart';

void showCustomPrimaryDialog(
  BuildContext context, {
  required Widget widget,
  bool canPop = true,
}) {
  showDialog<void>(
    context: context,
    useRootNavigator: false,
    barrierDismissible: canPop,
    builder: (context) {
      return PopScope(
        canPop: canPop,
        child: Dialog(
          backgroundColor: AppColors.offwhiteColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Padding(padding: EdgeInsets.all(16.r), child: widget),
        ),
      );
    },
  );
}
