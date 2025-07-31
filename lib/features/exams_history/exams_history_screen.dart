import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/helpers/app_localization.dart';
import 'package:smle/core/shared_widgets/custom_app_bar.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';
import 'package:smle/features/exams_history/cubit/exams_history_cubit.dart';
import 'package:smle/features/exams_history/data/models/exams_history_model.dart';

class ExamsHistoryScreen extends StatefulWidget {
  const ExamsHistoryScreen({super.key});

  @override
  State<ExamsHistoryScreen> createState() => _ExamsHistoryScreenState();
}

class _ExamsHistoryScreenState extends State<ExamsHistoryScreen> {
  @override
  void initState() {
    context.read<ExamsHistoryCubit>().fetchExamsHistory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<ExamsHistoryCubit>();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: CustomAppBar(title: 'exams_history'.tr(context)),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
          child: Column(
            children: [
              TabBar(
                unselectedLabelColor: AppColors.darkGreyColor,
                labelColor: AppColors.forthColor,
                indicator: const BoxDecoration(),
                dividerColor: Colors.transparent,
                tabs: [
                  Tab(text: 'pass'.tr(context)),
                  Tab(text: 'mid_level'.tr(context)),
                  Tab(text: 'fail'.tr(context)),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    ExamsList(exams: cubit.passedExams),
                    ExamsList(exams: cubit.midLevelExams),
                    ExamsList(exams: cubit.failedExams),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ExamsList extends StatelessWidget {
  const ExamsList({super.key, required this.exams});
  final List<Exam> exams;
  @override
  Widget build(BuildContext context) {
    if (exams.isEmpty) {
      return const Center(child: Text('no_exams_found'));
    }
    return ListView.separated(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      itemCount: exams.length,
      itemBuilder: (context, index) {
        final exam = exams[index];
        return ExamScoreCard(exam: exam);
      },
      separatorBuilder: (context, index) => 20.verticalSpace,
    );
  }
}

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
            fontSize: 16.sp,
            decoration: TextDecoration.underline,
          ),
        ),
        10.verticalSpace,
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            '$score ${'marks'.tr(context)}',
            style: interMedium.copyWith(fontSize: 16.sp),
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
                      '$score/100', // Removed percentage sign for clarity
                      style: interBold.copyWith(
                        fontSize: 14.sp,
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
      return AppColors.successColor;
    } else if (score < 40) {
      return AppColors.errorColor;
    } else {
      return AppColors.primaryColor; // Assuming you have a warning color
    }
  }
}
