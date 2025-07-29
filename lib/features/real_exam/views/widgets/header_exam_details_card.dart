import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smle/core/shared_widgets/custom_primary_dialog.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/features/real_exam/cubit/real_exam_cubit.dart';
import 'package:smle/features/real_exam/data/model/get_real_exam_model.dart';
import 'package:smle/features/real_exam/views/refactors/cutom_timer.dart';
import 'package:smle/features/real_exam/views/widgets/confirm_finish_exam_dialog.dart';

class HeaderExamDetailsCard extends StatelessWidget {
  const HeaderExamDetailsCard({
    required this.question,
    required this.totalQuestions,
    super.key,
  });

  final Question question;
  final int totalQuestions;

  @override
  Widget build(BuildContext context) {
    final qNo = question.questionNo;
    final section = question.section;
    final progressValue = qNo! / totalQuestions;

    return Column(
      children: [
        SizedBox(height: 8.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: AppColors.secondaryColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.r),
              topRight: Radius.circular(20.r),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Question: $qNo / $totalQuestions',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: AppColors.thirdColor,
                    ),
                  ),
                  4.verticalSpace,
                  Text(
                    'Section: $section',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: AppColors.thirdColor,
                    ),
                  ),
                  4.verticalSpace,
                  Column(
                    children: [
                      SizedBox(
                        width: 130.w,
                        child: LinearProgressIndicator(
                          minHeight: 20.h,
                          borderRadius: BorderRadius.circular(8.r),
                          value: progressValue,
                          backgroundColor: AppColors.thirdColor,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            AppColors.successColor,
                          ),
                        ),
                      ),
                      4.verticalSpace,
                      Text(
                        'Progress ${(progressValue * 100).toInt()}%',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: AppColors.thirdColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.alarm, color: AppColors.thirdColor),
                      8.verticalSpace,
                      Text(
                        'Section time remaining',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: AppColors.thirdColor,
                        ),
                      ),
                    ],
                  ),
                  5.verticalSpace,
                  const CustomTimerWidget(),
                  5.verticalSpace,

                  5.verticalSpace,
                  InkWell(
                    onTap: () {
                      final cubit = context.read<RealExamCubit>();
                      showCustomPrimaryDialog(
                        context,
                        widget: ConfirmFinishExamDialog(
                          cubit: cubit,
                          section: section!,
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(5.w),
                      decoration: BoxDecoration(
                        color: AppColors.thirdColor,
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(100.r),
                      ),
                      child: Text(
                        'Finish section',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.forthColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: AppColors.successColor,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20.r),
              bottomRight: Radius.circular(20.r),
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    'Test:',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: AppColors.thirdColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Saudi SLE License Examination',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: AppColors.thirdColor,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    'Candidate:',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: AppColors.thirdColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Saudi-Bot.com',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: AppColors.thirdColor,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Free Trial',
                    style: TextStyle(
                      color: const Color(0xFFEEEDEB),
                      fontSize: 18.sp,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                      height: 1.50.h,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
