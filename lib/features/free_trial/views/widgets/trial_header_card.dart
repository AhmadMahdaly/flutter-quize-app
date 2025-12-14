import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/shared_widgets/custom_primary_dialog.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';
import 'package:smle/features/free_trial/cubit/free_trial_cubit.dart';
import 'package:smle/features/free_trial/views/widgets/trial_exam_body.dart';
import 'package:smle/features/real_exam/views/widgets/cutom_timer.dart';

class TrialHeaderCard extends StatelessWidget {
  const TrialHeaderCard({
    required this.questionNumber,
    required this.totalQuestions,
    super.key,
  });

  final int questionNumber;
  final int totalQuestions;

  @override
  Widget build(BuildContext context) {
    final qNo = questionNumber;
    final progressValue = qNo / totalQuestions;
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 2.h),
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
                    style: AppTextStyle.style12W500.copyWith(
                      color: AppColors.thirdColor,
                    ),
                  ),

                  2.verticalSpace,
                  Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20.r),
                        child: SizedBox(
                          width: 130.w,
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
                      2.verticalSpace,
                      Text(
                        'Progress ${(progressValue * 100).toInt()}%',
                        style: AppTextStyle.style12W500.copyWith(
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
                        size: 20.r,
                      ),
                      4.horizontalSpace,
                      Text(
                        'Test time remaining',
                        style: AppTextStyle.style12W500.copyWith(
                          color: AppColors.thirdColor,
                        ),
                      ),
                    ],
                  ),
                  2.verticalSpace,
                  CustomTimerWidget(
                    endTime: DateTime.now().add(const Duration(hours: 2)),
                    onTimerFinish: () {
                      showCustomPrimaryDialog(
                        context,
                        widget: AlertDialog(
                          title: const Text("Time's Up!"),
                          content: const Text('The time for exam has ended.'),
                          actions: [
                            TextButton(
                              onPressed: () {},
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  2.verticalSpace,

                  InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => ResultsDialog(
                          state: context.read<TrialExamCubit>().state,
                          cubit: context.read<TrialExamCubit>(),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      decoration: BoxDecoration(
                        color: AppColors.thirdColor,
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(100.r),
                      ),
                      child: Text(
                        'Finish Exam',
                        style: AppTextStyle.style14Bold.copyWith(
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
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
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
              Text(
                'Test your knowledge with Smle Gate app',
                style: AppTextStyle.style12W500.copyWith(
                  color: AppColors.thirdColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
