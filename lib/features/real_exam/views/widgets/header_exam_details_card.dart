import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/features/real_exam/cubit/real_exam_cubit.dart';
import 'package:smle/features/real_exam/views/refactors/cutom_timer.dart';

class ExamDetailsCard extends StatelessWidget {
  const ExamDetailsCard({
    required this.currentIndex,
    super.key,
  });
  final int currentIndex;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RealExamCubit, RealExamState>(
      builder: (context, state) {
        final startExamData = context.read<RealExamCubit>().startRealExamModel;
        final qNo = startExamData?.data!.questionNo;
        final section = startExamData?.data!.section;

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
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ///  Exam data
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Question: $qNo',
                        style: TextStyle(
                            fontSize: 16.sp, color: AppColors.thirdColor),
                      ),
                      4.verticalSpace,
                      Text(
                        'Section: $section',
                        style: TextStyle(
                            fontSize: 16.sp, color: AppColors.thirdColor),
                      ),
                      4.verticalSpace,
                      if (currentIndex != 0)
                        Column(
                          children: [
                            SizedBox(
                              width: 130.w,
                              child: LinearProgressIndicator(
                                minHeight: 20.h,
                                borderRadius: BorderRadius.circular(8.r),
                                value: currentIndex /
                                    context
                                        .read<RealExamCubit>()
                                        .postRealExamOffsetList
                                        .length, // لا يتجاوز 100
                                backgroundColor: AppColors.thirdColor,
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  AppColors.successColor,
                                ),
                              ),
                            ),
                            4.verticalSpace,
                            Text(
                              'Progress ${((currentIndex / context.read<RealExamCubit>().postRealExamOffsetList.length) * 100).toInt()}%',
                              style: TextStyle(
                                  fontSize: 16.sp, color: AppColors.thirdColor),
                            ),
                          ],
                        ),
                    ],
                  ),

                  /// Timer
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
                                fontSize: 16.sp, color: AppColors.thirdColor),
                          ),
                        ],
                      ),
                      5.verticalSpace,
                      const CustomTimerWidget(),
                      5.verticalSpace,
                      Container(
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
                    ],
                  ),
                ],
              ),
            ),

            /// Sec Header
            /// Exam details
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
                            fontSize: 16.sp, color: AppColors.thirdColor),
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
                            fontSize: 16.sp, color: AppColors.thirdColor),
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
      },
    );
  }
}
