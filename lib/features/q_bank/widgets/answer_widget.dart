import 'package:flutter/material.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';

class AnswerWidget extends StatelessWidget {
  const AnswerWidget({
    super.key,
    required this.answerText,
    this.isSelected = false,
  });
  final String answerText;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.primaryColor.withAlpha(170)
            : AppColors.secondaryColor,
        border: Border.all(color: AppColors.primaryColor),
        borderRadius: BorderRadius.circular(15.r),
      ),
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
      alignment: Alignment.center,
      child: Text(
        answerText,
        style: AppTextStyle.style14Bold.copyWith(
          color: isSelected ? AppColors.secondaryColor : AppColors.thirdColor,
        ),
      ),
    );
  }
}

class AnsweredWidget extends StatelessWidget {
  const AnsweredWidget({
    super.key,
    required this.answerText,
    required this.isTrue,
    required this.isSelected,
  });
  final String answerText;
  final bool isTrue;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    Color getBackgroundColor() {
      if (isTrue) {
        return AppColors.successColor;
      } else if (isSelected) {
        return AppColors.primaryColor;
      } else {
        return AppColors.secondaryColor;
      }
    }

    Color getBorderColor() {
      if (isTrue || isSelected) {
        return Colors.transparent;
      } else {
        return AppColors.primaryColor;
      }
    }

    Color getTextColor() {
      if (isTrue || isSelected) {
        return AppColors.secondaryColor;
      } else {
        return AppColors.thirdColor;
      }
    }

    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      decoration: BoxDecoration(
        color: getBackgroundColor(),
        border: Border.all(color: getBorderColor()),
        borderRadius: BorderRadius.circular(15.r),
      ),
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
      alignment: Alignment.center,
      child: Text(
        answerText,
        style: AppTextStyle.style14Bold.copyWith(color: getTextColor()),
      ),
    );
  }
}
