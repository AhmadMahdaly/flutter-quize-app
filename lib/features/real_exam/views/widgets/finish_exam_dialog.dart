import 'package:flutter/material.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/helpers/extensions.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';
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
        6.verticalSpace,
        Container(
          padding: EdgeInsets.all(10.r),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(360.r),
            border: Border.all(color: AppColors.darkGreyColor),
          ),
          child: Icon(
            Icons.question_mark_rounded,
            color: AppColors.darkGreyColor,
            size: 56.r,
          ),
        ),
        Text(
          textAlign: TextAlign.center,
          isSection1 ? 'Finish Section 1?' : 'Finish The Exam?',
          style: interBold.copyWith(
            fontSize: SizeConfig.responsiveValue(phone: 18.sp, tablet: 22.sp),
            color: AppColors.iconColorGray,
          ),
        ),
        if (isSection1)
          Text(
            textAlign: TextAlign.center,
            'You will start a 30-minute break',
            style: interMedium.copyWith(
              fontSize: SizeConfig.responsiveValue(phone: 16.sp, tablet: 18.sp),
              color: AppColors.iconColorGray,
            ),
          ),
        Row(
          spacing: 6.w,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: TextButton(
                onPressed: () {
                  context.pop();
                  if (isSection1) {
                    cubit.finishSection1AndStartBreak();
                  } else {
                    cubit.finishExam();
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8.r, horizontal: 8.w),
                  decoration: BoxDecoration(
                    color: AppColors.greenColor,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    isSection1 ? 'Yes, start break' : 'Yes, Finish Exam',
                    style: interBold.copyWith(
                      fontSize: SizeConfig.responsiveValue(
                        phone: 14.sp,
                        tablet: 18.sp,
                      ),
                      color: AppColors.offwhiteColor,
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
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: AppColors.errorColor,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    'Cancel',
                    style: interBold.copyWith(
                      fontSize: SizeConfig.responsiveValue(
                        phone: 14.sp,
                        tablet: 18.sp,
                      ),
                      color: AppColors.offwhiteColor,
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
