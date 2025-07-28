import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smle/core/theme/colors.dart';

class NextQuestionItem extends StatelessWidget {
  const NextQuestionItem({required this.text, required this.color, super.key});
  final String text;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60.w,
      height: 30.h,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: AppColors.thirdColor,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
