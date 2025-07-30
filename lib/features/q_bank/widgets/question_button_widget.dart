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
      width: 140.w,
      height: 50.h,
      decoration: BoxDecoration(
        color: AppColors.secondaryColor,
        borderRadius: BorderRadius.circular(40.r),
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: interBold.copyWith(
          color: AppColors.thirdColor,
          fontSize: SizeConfig.responsiveValue(phone: 16.sp, tablet: 20.sp),
        ),
      ),
    );
  }
}
