import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smle/core/di.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/helpers/extensions.dart';
import 'package:smle/core/shared_widgets/custom_primary_dialog.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';
import 'package:smle/features/check_subscription/check_subscription_cubit.dart';
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

    final cubit = context.watch<RealExamCubit>();
    final sectionEndTimeString = cubit.state.sectionEndTimes[section];
    final endTime = sectionEndTimeString != null
        ? DateTime.parse(sectionEndTimeString)
        : DateTime.now();

    return Column(
      children: [
        // 8.verticalSpace,
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: 12.w,
            vertical: SizeConfig.responsiveValue(phone: 4.h, tablet: 4.h),
          ),
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
                  SizeConfig.responsiveValue(
                    phone: 2.verticalSpace,
                    tablet: 2.verticalSpace,
                  ),
                  Text(
                    'Section: $section',
                    style: AppTextStyle.style12W500.copyWith(
                      color: AppColors.thirdColor,
                    ),
                  ),
                  SizeConfig.responsiveValue(
                    phone: 2.verticalSpace,
                    tablet: 2.verticalSpace,
                  ),
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
                            minHeight: SizeConfig.responsiveValue(
                              phone: 15.h,
                              tablet: 10.h,
                            ),
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
                        size: SizeConfig.responsiveValue(
                          phone: 20.h,
                          tablet: 18.h,
                        ),
                      ),
                      5.horizontalSpace,
                      Text(
                        'Section time remaining',
                        style: AppTextStyle.style12W500.copyWith(
                          color: AppColors.thirdColor,
                        ),
                      ),
                    ],
                  ),
                  SizeConfig.responsiveValue(
                    phone: 2.verticalSpace,
                    tablet: 2.verticalSpace,
                  ),
                  CustomTimerWidget(
                    endTime: endTime,
                    onTimerFinish: () {
                      showCustomPrimaryDialog(
                        canPop: false,
                        context,
                        widget: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text("Time's Up!"),
                            Text('The time for section $section has ended.'),

                            TextButton(
                              onPressed: () async {
                                if (context.mounted) {
                                  context.pop();

                                  if (section == 1) {
                                    cubit.finishSection1AndStartBreak();
                                  } else {
                                    await cubit.finishExam();
                                    cubit.resetExam();
                                    await getIt<CheckSubscriptionCubit>()
                                        .loadAllSubscriptions();
                                  }
                                }
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  SizeConfig.responsiveValue(
                    phone: 2.verticalSpace,
                    tablet: 2.verticalSpace,
                  ),

                  InkWell(
                    onTap: () {
                      final cubit = context.read<RealExamCubit>();
                      if (cubit.state.bookmarkedStatuses.values.contains(
                        true,
                      )) {
                        showCustomPrimaryDialog(
                          context,
                          widget: ConfirmHasFlagDialog(
                            onPressed: () {
                              if (context.mounted) context.pop();
                              showCustomPrimaryDialog(
                                context,
                                widget: ConfirmFinishExamDialog(
                                  cubit: cubit,
                                  section: section!,
                                ),
                              );
                            },
                          ),
                        );
                      } else {
                        showCustomPrimaryDialog(
                          context,
                          widget: ConfirmFinishExamDialog(
                            cubit: cubit,
                            section: section!,
                          ),
                        );
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: SizeConfig.responsiveValue(
                          phone: 2.h,
                          tablet: 2.h,
                        ),
                        horizontal: 10.w,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.thirdColor,
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(100.r),
                      ),
                      child: Text(
                        'Finish section',
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
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
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
