import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/shared_widgets/custom_primary_dialog.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';
import 'package:smle/features/real_exam/cubit/real_exam_cubit.dart';
import 'package:smle/features/real_exam/data/model/get_real_exam_model.dart';
import 'package:smle/features/real_exam/views/widgets/cutom_timer.dart';
import 'package:smle/features/real_exam/views/widgets/finish_exam_dialog.dart';

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

    // Get the timer state from the cubit
    final cubit = context.watch<RealExamCubit>();
    final sectionEndTimeString = cubit.state.sectionEndTimes[section];
    final endTime = sectionEndTimeString != null
        ? DateTime.parse(sectionEndTimeString)
        : DateTime.now();

    return Column(
      children: [
        8.verticalSpace,
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: AppColors.secondaryColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(
                SizeConfig.responsiveValue(phone: 20.r, tablet: 12.r),
              ),
              topRight: Radius.circular(
                SizeConfig.responsiveValue(phone: 20.r, tablet: 12.r),
              ),
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
                    style: interRegular.copyWith(
                      fontSize: SizeConfig.responsiveValue(
                        phone: 14.sp,
                        tablet: 20.sp,
                      ),
                      color: AppColors.thirdColor,
                    ),
                  ),
                  4.verticalSpace,
                  Text(
                    'Section: $section',
                    style: interRegular.copyWith(
                      fontSize: SizeConfig.responsiveValue(
                        phone: 14.sp,
                        tablet: 20.sp,
                      ),
                      color: AppColors.thirdColor,
                    ),
                  ),
                  4.verticalSpace,
                  Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20.r),
                        child: SizedBox(
                          width: SizeConfig.responsiveValue(
                            phone: 120.w,
                            tablet: 130.w,
                          ),
                          child: LinearProgressIndicator(
                            minHeight: 20.h,
                            value: progressValue,
                            backgroundColor: AppColors.thirdColor,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              AppColors.successColor,
                            ),
                          ),
                        ),
                      ),
                      4.verticalSpace,
                      Text(
                        'Progress ${(progressValue * 100).toInt()}%',
                        style: interRegular.copyWith(
                          fontSize: SizeConfig.responsiveValue(
                            phone: 14.sp,
                            tablet: 20.sp,
                          ),
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
                      Icon(
                        Icons.alarm,
                        color: AppColors.thirdColor,
                        size: SizeConfig.responsiveValue(
                          phone: 20.h,
                          tablet: 24.h,
                        ),
                      ),
                      4.horizontalSpace,
                      Text(
                        'Section time remaining',
                        style: interRegular.copyWith(
                          fontSize: SizeConfig.responsiveValue(
                            phone: 14.sp,
                            tablet: 20.sp,
                          ),
                          color: AppColors.thirdColor,
                        ),
                      ),
                    ],
                  ),
                  5.verticalSpace,
                  CustomTimerWidget(
                    endTime: endTime,
                    onTimerFinish: () {
                      // This will be called when the timer hits zero.
                      // You can show a dialog or automatically end the section.
                      showCustomPrimaryDialog(canPop:false,
                        context,
                        widget: Column(mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text("Time's Up!"),
                            Text('The time for section $section has ended.'),

                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                // Logic to end the section
                                if (section == 1) {
                                  cubit.finishSection1AndStartBreak();
                                } else {
                                  cubit.finishExam();
                                }
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
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
                      padding: EdgeInsets.symmetric(
                        vertical: 5.w,
                        horizontal: 10.w,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.thirdColor,
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(100.r),
                      ),
                      child: Text(
                        'Finish section',
                        style: interBold.copyWith(
                          fontSize: SizeConfig.responsiveValue(
                            phone: 16.sp,
                            tablet: 24.sp,
                          ),
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
              bottomLeft: Radius.circular(
                SizeConfig.responsiveValue(phone: 20.r, tablet: 12.r),
              ),
              bottomRight: Radius.circular(
                SizeConfig.responsiveValue(phone: 20.r, tablet: 12.r),
              ),
            ),
          ),
          child: Column(
            children: [
              // Row(
              //   children: [
                  // Text(
                  //   'Test:',
                  //   style: interRegular.copyWith(
                  //     fontSize: SizeConfig.responsiveValue(
                  //       phone: 14.sp,
                  //       tablet: 20.sp,
                  //     ),
                  //     color: AppColors.thirdColor,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  // ),
                  Text(
                    'Test your knowledge with Smle Gate app',
                    style: interRegular.copyWith(
                      fontSize: SizeConfig.responsiveValue(
                        phone: 14.sp,
                        tablet: 20.sp,
                      ),
                      color: AppColors.thirdColor,
                    ),
                  ),
              //   ],
              // ),
              // Row(
              //   children: [
              //     Text(
              //       'Candidate:',
              //       style: interRegular.copyWith(
              //         fontSize: SizeConfig.responsiveValue(
              //           phone: 14.sp,
              //           tablet: 20.sp,
              //         ),
              //         color: AppColors.thirdColor,
              //         fontWeight: FontWeight.bold,
              //       ),
              //     ),
              //     Text(
              //       'Saudi-Bot.com',
              //       style: interRegular.copyWith(
              //         fontSize: SizeConfig.responsiveValue(
              //           phone: 14.sp,
              //           tablet: 20.sp,
              //         ),
              //         color: AppColors.thirdColor,
              //       ),
              //     ),
              //     const Spacer(),
              //     // Text(
              //     //   'Free Trial',
              //     //   style: interBold.copyWith(
              //     //     fontSize: SizeConfig.responsiveValue(
              //     //       phone: 18.sp,
              //     //       tablet: 22.sp,
              //     //     ),
              //     //     color: AppColors.offwhiteColor,
              //     //     fontWeight: FontWeight.w700,
              //     //     height: 1.50.h,
              //     //   ),
              //     // ),
              //   ],
              // ),
            ],
          ),
        ),
      ],
    );
  }
}
