import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smle/core/helpers/extensions.dart';
import 'package:smle/core/shared_widgets/custom_primary_dialog.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';
import 'package:smle/features/real_exam/cubit/real_exam_cubit.dart';
import 'package:smle/features/real_exam/views/widgets/break_time_dailog.dart';

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
    return section == 1
        ? Column(
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
                'Finish Section 1?',
                style: interBold.copyWith(
                  fontSize: 18.sp,
                  color: AppColors.iconColorGray,
                ),
              ),
              Text(
                textAlign: TextAlign.center,
                'You will start a 30-minute break',
                style: interMedium.copyWith(
                  fontSize: 16.sp,
                  color: AppColors.iconColorGray,
                ),
              ),
              Row(
                spacing: 6.w,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    onPressed: () async {
                      context.pop();
                      context.pop();
                      if (context.mounted) {
                        showCustomPrimaryDialog(
                          canPop: false,
                          context,
                          widget: const BreakTimeDialog(),
                        );
                      }
                      // cubit.finishAnalysisExam();
                    },
                    child: Container(
                      height: 42.h,
                      padding: EdgeInsets.symmetric(
                        vertical: 8.r,
                        horizontal: 8.w,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.greenColor,
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        'Yes, start break',
                        style: interBold.copyWith(
                          fontSize: 14.sp,
                          color: AppColors.offwhiteColor,
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      context.pop();
                    },
                    child: Container(
                      height: 42.h,
                      padding: EdgeInsets.all(8.r),
                      decoration: BoxDecoration(
                        color: AppColors.errorColor,
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        'Cancel',
                        style: interBold.copyWith(
                          fontSize: 14.sp,
                          color: AppColors.offwhiteColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )
        : Column(
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
                'Finish The Exam?',
                style: interBold.copyWith(
                  fontSize: 18.sp,
                  color: AppColors.iconColorGray,
                ),
              ),

              Row(
                spacing: 6.w,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    onPressed: () async {
                      context.pop();
                      cubit.finishAnalysisExam();
                    },
                    child: Container(
                      height: 42.h,
                      padding: EdgeInsets.symmetric(
                        vertical: 8.r,
                        horizontal: 8.w,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.greenColor,
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        'Yes, Finish Exam',
                        style: interBold.copyWith(
                          fontSize: 14.sp,
                          color: AppColors.offwhiteColor,
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      context.pop();
                    },
                    child: Container(
                      height: 42.h,
                      padding: EdgeInsets.all(8.r),
                      decoration: BoxDecoration(
                        color: AppColors.errorColor,
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        'Cancel',
                        style: interBold.copyWith(
                          fontSize: 14.sp,
                          color: AppColors.offwhiteColor,
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
