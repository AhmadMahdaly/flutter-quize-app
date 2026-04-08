import 'package:flutter/material.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';

class QuestionButtonWidget extends StatelessWidget {
  const QuestionButtonWidget({super.key, required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120.w,
      height: 56.h,
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      alignment: Alignment.center,
      child: FittedBox(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Text(
            text,
            style: AppTextStyle.style14Bold.copyWith(
              color: AppColors.thirdColor,
            ),
          ),
        ),
      ),
    );
  }
}

class CustomQuestionButtonWidget extends StatelessWidget {
  const CustomQuestionButtonWidget({super.key, required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300.w,
      height: 56.h,
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      alignment: Alignment.center,
      child: FittedBox(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Text(
            text,
            style: AppTextStyle.style14Bold.copyWith(
              color: AppColors.thirdColor,
            ),
          ),
        ),
      ),
    );
  }
}
