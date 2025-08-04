import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';
import 'package:smle/features/free_trial/cubit/free_trial_cubit.dart';
import 'package:smle/features/free_trial/data/models/trial_exam_model.dart';

class TrialQuestionWidget extends StatelessWidget {
  const TrialQuestionWidget({required this.question, super.key});
  final TrialQuestion question;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<TrialExamCubit>();
    final userAnswer = context.select(
      (TrialExamCubit c) => c.state.userAnswers[question.id],
    );
    final hasAnswered = userAnswer != null;

    return Container(
      padding: EdgeInsets.all(4.r),
      decoration: BoxDecoration(
        color: AppColors.thirdColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.greyColor),
      ),
      child: Container(
        padding: EdgeInsets.all(8.r),
        decoration: BoxDecoration(
          color: AppColors.offwhiteColor,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.greyColor),
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(8.sp),
                child: Column(
                  children: [
                    Text(
                      question.question,

                      style: interRegular.copyWith(
                        fontSize: SizeConfig.responsiveValue(
                          phone: 14.sp,
                          tablet: 20.sp,
                        ),
                      ),
                    ),
                    if (question.photo != null && question.photo!.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        child: Image.network(
                          question.photo!,
                          errorBuilder: (context, error, stackTrace) =>
                              const SizedBox.shrink(),
                        ),
                      ),
                    16.verticalSpace,
                    _buildOption(
                      'a',
                      question.a,
                      cubit,
                      userAnswer,
                      hasAnswered,
                    ),
                    _buildOption(
                      'b',
                      question.b,
                      cubit,
                      userAnswer,
                      hasAnswered,
                    ),
                    _buildOption(
                      'c',
                      question.c,
                      cubit,
                      userAnswer,
                      hasAnswered,
                    ),
                    _buildOption(
                      'd',
                      question.d,
                      cubit,
                      userAnswer,
                      hasAnswered,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(
    String optionLetter,
    String text,
    TrialExamCubit cubit,
    String? userAnswer,
    bool hasAnswered,
  ) {
    final isSelected = userAnswer == optionLetter;
    final isCorrect = question.answer == optionLetter;
    Color borderColor = AppColors.darkGreyColor;
    Color backgroundColor = Colors.white;
    Color textColor = Colors.black;

    if (hasAnswered) {
      if (isSelected) {
        backgroundColor = isCorrect
            ? Colors.green.shade100
            : Colors.red.shade100;
        borderColor = isCorrect ? Colors.green : Colors.red;
        textColor = isCorrect ? Colors.green.shade900 : Colors.red.shade900;
      } else if (isCorrect) {
        backgroundColor = Colors.green.shade100;
        borderColor = Colors.green;
        textColor = Colors.green.shade900;
      }
    }

    return GestureDetector(
      onTap: hasAnswered
          ? null
          : () => cubit.answerQuestion(question.id, optionLetter),
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(vertical: 4.h),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: borderColor, width: 0.5.w),
        ),
        child: Text(
          text,
          style: interRegular.copyWith(
            fontSize: SizeConfig.responsiveValue(phone: 12.sp, tablet: 18.sp),
            fontWeight: hasAnswered && (isSelected || isCorrect)
                ? FontWeight.bold
                : FontWeight.normal,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
