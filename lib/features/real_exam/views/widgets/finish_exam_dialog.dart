import 'package:flutter/material.dart';
import 'package:smle/core/di.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/helpers/extensions.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';
import 'package:smle/features/check_subscription/check_subscription_cubit.dart';
import 'package:smle/features/real_exam/cubit/real_exam_cubit.dart';

class ConfirmFinishExamDialog extends StatelessWidget {
  const ConfirmFinishExamDialog({
    super.key,
    required this.cubit,
    required this.section,
  });
  final RealExamCubit cubit;
  final int section;
  @override
  Widget build(BuildContext context) {
    final isSection1 = section == 1;
    return Column(
      spacing: 12.h,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,

      children: [
        1.verticalSpace,
        Container(
          padding: EdgeInsets.all(10.r),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(360.r),
            border: Border.all(color: AppColors.darkGreyColor),
          ),
          child: Icon(
            Icons.question_mark_rounded,
            color: AppColors.primaryColor,
            size: 56.r,
          ),
        ),
        10.verticalSpace,
        Text(
          textAlign: TextAlign.center,
          isSection1 ? 'Finish Section 1?' : 'Finish The Exam?',
          style: AppTextStyle.style18Bold.copyWith(color: AppColors.thirdColor),
        ),
        if (isSection1)
          Text(
            textAlign: TextAlign.center,
            'You will start a 30-minute break',
            style: AppTextStyle.style16W700.copyWith(
              color: AppColors.thirdColor,
            ),
          ),
        Row(
          spacing: 6.w,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: TextButton(
                onPressed: () async {
                  if (context.mounted) {
                    context.pop();

                    if (isSection1) {
                      cubit.finishSection1AndStartBreak();
                    } else {
                      await cubit.finishExam();
                      cubit.resetExam();
                      await getIt<CheckSubscriptionCubit>().loadSubscription();
                    }
                  }
                },
                child: Container(
                  height: 60.h,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 8.r, horizontal: 8.w),
                  decoration: BoxDecoration(
                    color: AppColors.successColor,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: FittedBox(
                    child: Text(
                      isSection1 ? 'Yes,\nStart break' : 'Yes,\nFinish Exam',
                      textAlign: TextAlign.center,
                      style: AppTextStyle.style14Bold.copyWith(
                        color: AppColors.offwhiteColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: TextButton(
                onPressed: () {
                  context.pop();
                },
                child: Container(
                  height: 60.h,
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: AppColors.errorColor.withAlpha(170),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: FittedBox(
                    child: Text(
                      'Cancel',
                      style: AppTextStyle.style14Bold.copyWith(
                        color: AppColors.offwhiteColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class ConfirmHasFlagDialog extends StatelessWidget {
  const ConfirmHasFlagDialog({super.key, required this.onPressed});
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8.h,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,

      children: [
        1.verticalSpace,
        Container(
          padding: EdgeInsets.all(10.r),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(360.r),
            border: Border.all(color: AppColors.darkGreyColor),
          ),
          child: Icon(
            Icons.flag_rounded,
            color: AppColors.primaryColor,
            size: 56.r,
          ),
        ),
        10.verticalSpace,
        Text(
          textAlign: TextAlign.center,
          'You have flagged questions',
          style: AppTextStyle.style18Bold.copyWith(
            color: AppColors.iconColorGray,
          ),
        ),

        Text(
          textAlign: TextAlign.center,
          'Are you sure you want to end this section?',
          style: AppTextStyle.style16W700.copyWith(
            color: AppColors.iconColorGray,
          ),
        ),
        Row(
          spacing: 6.w,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: TextButton(
                onPressed: onPressed,

                child: Container(
                  height: 40.h,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 8.r, horizontal: 8.w),
                  decoration: BoxDecoration(
                    color: AppColors.successColor,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: FittedBox(
                    child: Text(
                      'Yes',
                      textAlign: TextAlign.center,
                      style: AppTextStyle.style14Bold.copyWith(
                        color: AppColors.offwhiteColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: TextButton(
                onPressed: () {
                  context.pop();
                },
                child: Container(
                  height: 40.h,
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: AppColors.errorColor.withAlpha(170),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: FittedBox(
                    child: Text(
                      'Cancel',
                      style: AppTextStyle.style14Bold.copyWith(
                        color: AppColors.offwhiteColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
