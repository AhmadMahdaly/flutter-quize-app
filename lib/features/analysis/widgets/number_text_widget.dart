import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';

class NumberTextWidget extends StatelessWidget {
  const NumberTextWidget({super.key, required this.text, required this.number});
final String text,number;
  @override
  Widget build(BuildContext context) {
    return                  Container(
      decoration: BoxDecoration(
          color: AppColors.darkGreyColor,
          borderRadius: BorderRadius.all(Radius.circular( 50.r))
      ),
      padding: EdgeInsets.symmetric(vertical: 15.h,horizontal: 15.w),
      child: Column(
          children: [
            Text(text,style: interBold.copyWith(fontSize: 14.sp,color: AppColors.thirdColor),),
            Text(number,style: interBold.copyWith(fontSize: 24.sp,color: AppColors.thirdColor),)]),
    );
  }
}
