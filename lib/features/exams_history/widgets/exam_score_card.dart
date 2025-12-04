import 'package:flutter/material.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/helpers/app_localization.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';
import 'package:smle/features/exams_history/data/models/exams_history_model.dart';

class ExamScoreCard extends StatelessWidget {
  const ExamScoreCard({super.key, required this.exam});

  final Exam exam;

  @override
  Widget build(BuildContext context) {
    final num score = exam.score ?? 0.0;
    final Color progressColor = _getProgressColor(score);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${'exam'.tr(context)} ${exam.examNo}',
              style: AppTextStyle.style16Bold,
            ),
            Text(
              '$score ${'marks'.tr(context)}',
              style: AppTextStyle.style16W700.copyWith(
                color: AppColors.forthColor,
              ),
            ),
          ],
        ),

        10.verticalSpace,
        ClipRRect(
          borderRadius: BorderRadius.circular(30.r),
          child: SizedBox(
            height: 40.h,
            child: Stack(
              alignment: Alignment.center,
              children: [
                LinearProgressIndicator(
                  value: score / 100.0,
                  backgroundColor: AppColors.greyColor,
                  color: progressColor,
                  minHeight: 40.h,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: 8.w),
                    child: Text(
                      '$score/100',
                      style: AppTextStyle.style14W900.copyWith(
                        color: AppColors.forthColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Color _getProgressColor(num score) {
    if (score >= 60) {
      return AppColors.greenColor;
    } else if (score < 40) {
      return AppColors.errorColor;
    } else {
      return AppColors.primaryColor;
    }
  }
}
