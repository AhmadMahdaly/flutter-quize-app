import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';
import 'package:smle/features/exams_history/cubit/exams_history_cubit.dart';
import 'package:smle/features/exams_history/data/models/exams_history_model.dart';

class ExamScoreCard extends StatelessWidget {
  const ExamScoreCard({super.key, required this.exam});

  final Exam exam;

  @override
  Widget build(BuildContext context) {
    final num score = exam.score ?? 0.0;
    final Color progressColor = _getProgressColor(score);

    return Dismissible(
      key: Key(exam.examId.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: AlignmentDirectional.centerEnd,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          color: AppColors.errorColor,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Icon(Icons.delete_outline, color: Colors.white, size: 30.r),
      ),
      confirmDismiss: (DismissDirection direction) async {
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Confirm Deletion'),
              content: Text(
                'Are you sure you want to delete this exam?\n'
                'Please note that deleting any exam will affect your total results analysis.',
                style: AppTextStyle.style14W700,
              ),
              actions: [
                TextButton(
                  onPressed: () =>
                      Navigator.of(context).pop(false), // إلغاء الحذف
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                TextButton(
                  onPressed: () =>
                      Navigator.of(context).pop(true), // تأكيد الحذف
                  child: const Text(
                    'Delete',
                    style: TextStyle(color: AppColors.errorColor),
                  ),
                ),
              ],
            );
          },
        );
      },
      onDismissed: (direction) {
        context.read<ExamsHistoryCubit>().deleteExamHistory(
          exam.examId.toString(),
        );
      },
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${'Exam'} ${exam.examNo}',
                    style: AppTextStyle.style16Bold,
                  ),
                  Text(
                    '$score ${'Marks'}',
                    style: AppTextStyle.style16W700.copyWith(
                      color: AppColors.primaryColor,
                    ),
                  ),
                ],
              ),

              10.verticalSpace,
              ClipRRect(
                borderRadius: BorderRadius.circular(30.r),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    LinearProgressIndicator(
                      value: score / 100.0,
                      backgroundColor: AppColors.greyColor,
                      color: progressColor,
                      minHeight: 20.h,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.only(right: 8.w),
                        child: Text(
                          '$score/100',
                          style: AppTextStyle.style12W900.copyWith(
                            color: AppColors.forthColor,
                            fontSize: 10.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
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
