import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';
import 'package:smle/features/q_bank/cubit/q_bank_cubit.dart';

class AnswerWidget extends StatelessWidget {
  const AnswerWidget({
    super.key,
    required this.answerText,
    this.isSelected,
    required this.isTrue,
  });
  final String answerText;
  final bool? isSelected;
  final bool isTrue;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      decoration: BoxDecoration(
        color: isSelected == true && isTrue == false
            ? AppColors.errorColor
            : context
                          .read<QBankcubit>()
                          .qBankModel!
                          .data![context.read<QBankcubit>().index]
                          .selectedAnswer !=
                      null &&
                  isTrue
            ? AppColors.successColor
            : AppColors.primaryColor,
        borderRadius: BorderRadius.circular(40.r),
        // border: isSelected ? Border.all(color: AppColors.secondaryColor, width: 2) : null,
      ),
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
      alignment: Alignment.center,
      child: Text(
        answerText,
        style: interBold.copyWith(
          color: AppColors.secondaryColor,
          fontSize: 16.sp,
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
  });
  final String answerText;
  final bool isTrue;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      decoration: BoxDecoration(
        color: isTrue ? AppColors.successColor : AppColors.primaryColor,
        borderRadius: BorderRadius.circular(40.r),
      ),
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
      alignment: Alignment.center,
      child: Text(
        answerText,
        style: interBold.copyWith(
          color: AppColors.secondaryColor,
          fontSize: 16.sp,
        ),
      ),
    );
  }
}
