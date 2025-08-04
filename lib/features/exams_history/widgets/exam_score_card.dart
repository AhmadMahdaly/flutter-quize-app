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
    final int score = exam.score ?? 0;
    final Color progressColor = _getProgressColor(score);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${'exam'.tr(context)} ${exam.examNo}',
          style: interBold.copyWith(
            fontSize: SizeConfig.responsiveValue(phone: 16.sp, tablet: 20.sp),
          ),
        ),
        10.verticalSpace,
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            '$score ${'marks'.tr(context)}',
            style: interMedium.copyWith(
              fontSize: SizeConfig.responsiveValue(phone: 16.sp, tablet: 20.sp),
              color: AppColors.forthColor,
            ),
          ),
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
                      style: interBold.copyWith(
                        fontSize: SizeConfig.responsiveValue(
                          phone: 14.sp,
                          tablet: 18.sp,
                        ),
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

  Color _getProgressColor(int score) {
    if (score >= 60) {
      return AppColors.greenColor;
    } else if (score < 40) {
      return AppColors.errorColor;
    } else {
      return AppColors.primaryColor;
    }
  }
}
