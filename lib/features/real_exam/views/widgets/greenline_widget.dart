import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smle/core/theme/colors.dart';

class GreenlineWidget extends StatelessWidget {
  const GreenlineWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 359.w,
      height: 5.h,
      decoration: ShapeDecoration(
        color: AppColors.successColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.r),
            topRight: Radius.circular(10.r),
          ),
        ),
      ),
    );
  }
}
