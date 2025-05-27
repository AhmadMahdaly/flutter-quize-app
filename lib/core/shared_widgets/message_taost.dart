 import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

import '../../core/theme/text_styles.dart';




messageToast(BuildContext context,String message){
  return    showToastWidget(
    Padding(
      padding:  EdgeInsets.symmetric(horizontal: 2.h),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        margin: const EdgeInsets.symmetric(horizontal: 50.0),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          color: Theme.of(context).primaryColor.withOpacity(0.65),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding:  EdgeInsets.symmetric(vertical: 5.h,horizontal: 5.w),
              child: Center(
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                  style: interRegular.copyWith(color: Theme.of(context).cardColor)
                ),
              ),
            ),
          ],
        ),
      ),
    ),
    context: context,
    position: StyledToastPosition.top,
    isIgnoring: false,
    duration: const Duration(seconds: 3),
  );
}