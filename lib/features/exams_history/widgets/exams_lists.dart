import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/helpers/app_localization.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';
import 'package:smle/features/exams_history/cubit/exams_history_cubit.dart';
import 'package:smle/features/exams_history/widgets/exam_score_card.dart';

class ExamsList extends StatelessWidget {
  const ExamsList({super.key, required this.cubit});
  final ExamsHistoryCubit cubit;
  @override
  Widget build(BuildContext context) {
    log(cubit.state.toString());
    if (cubit.allExams.isEmpty && cubit.state is! ExamsHistoryLoading) {
      return Center(
        child: Text(
          'no_exams_found'.tr(context),
          style: AppTextStyle.style16Bold.copyWith(color: AppColors.forthColor),
        ),
      );
    }
    return ListView.separated(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      itemCount: cubit.allExams.length,
      itemBuilder: (context, index) {
        final exam = cubit.allExams[index];
        return ExamScoreCard(exam: exam);
      },
      separatorBuilder: (context, index) => 20.verticalSpace,
    );
  }
}
