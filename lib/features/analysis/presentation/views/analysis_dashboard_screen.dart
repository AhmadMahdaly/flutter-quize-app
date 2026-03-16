// ignore_for_file: unnecessary_null_comparison

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/helpers/extensions.dart';
import 'package:smle/core/routing/routes.dart';
import 'package:smle/core/shared_widgets/custom_app_bar.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';
import 'package:smle/features/analysis/data/model/analysis_model.dart';
import 'package:smle/features/analysis/presentation/cubit/analysis_cubit.dart';
import 'package:smle/features/analysis/presentation/views/widgets/analysis_chart_widget.dart';
import 'package:smle/features/exams_history/cubit/exams_history_cubit.dart';
import 'package:smle/features/exams_history/data/models/exams_history_model.dart';
import 'package:smle/features/exams_history/widgets/exam_score_card.dart';

class AnalysisDashboardScreen extends StatefulWidget {
  const AnalysisDashboardScreen({super.key});

  @override
  State<AnalysisDashboardScreen> createState() =>
      _AnalysisDashboardScreenState();
}

class _AnalysisDashboardScreenState extends State<AnalysisDashboardScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AnalysisCubit>().getAnalysis();
    context.read<ExamsHistoryCubit>().fetchExamsHistory();
  }

  @override
  Widget build(BuildContext context) {
    final examsCubit = context.watch<ExamsHistoryCubit>();

    return Scaffold(
      appBar: const CustomAppBar(title: 'Analysis'),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _OverallAnalysisSection(),

            30.verticalSpace,

            Text('Exams', style: AppTextStyle.style16Bold),
            16.verticalSpace,

            BlocBuilder<ExamsHistoryCubit, ExamsHistoryState>(
              builder: (context, state) {
                if (state is ExamsHistoryLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is ExamsHistorySuccess &&
                        examsCubit.allExams.isEmpty ||
                    state is ExamsHistorySuccess &&
                        examsCubit.allExams == null) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ((SizeConfig.screenHeight / 2) - 300).verticalSpace,
                      Icon(
                        Icons.edit_document,
                        color: AppColors.darkGreyColor.withAlpha(100),
                        size: 160.r,
                      ),
                      12.verticalSpace,
                      Center(
                        child: Text(
                          'No Exams found',
                          style: AppTextStyle.style16W700.copyWith(
                            color: AppColors.darkGreyColor.withAlpha(100),
                          ),
                        ),
                      ),
                    ],
                  );
                }

                if (state is ExamsHistorySuccess) {
                  return Column(
                    children: examsCubit.allExams
                        .map(
                          (exam) => Dismissible(
                            key: Key(exam.examId.toString()),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              alignment: AlignmentDirectional.centerEnd,
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              decoration: BoxDecoration(
                                color: AppColors.errorColor,
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: const Icon(
                                Icons.delete_outline,
                                color: Colors.white,
                                size: 30,
                              ),
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
                                        onPressed: () => Navigator.of(
                                          context,
                                        ).pop(false), // إلغاء الحذف
                                        child: const Text(
                                          'Cancel',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.of(
                                          context,
                                        ).pop(true), // تأكيد الحذف
                                        child: const Text(
                                          'Delete',
                                          style: TextStyle(
                                            color: AppColors.errorColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            onDismissed: (direction) {
                              // سيتم استدعاء هذا الكود فقط إذا اختار المستخدم "Delete" وأرجع الديالوج true
                              examsCubit.deleteExamHistory(
                                exam.examId.toString(),
                              );
                            },
                            child: InkWell(
                              onTap: () => context.pushNamed(
                                AppRoutes.examAnalysisScreen,
                                arguments: exam,
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(bottom: 16.h),
                                child: ExamScoreCard(exam: exam),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  );
                }

                if (state is ExamsHistoryFailure) {
                  return Center(child: Text(state.errorMessage));
                }

                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _OverallAnalysisSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final exams = context.watch<ExamsHistoryCubit>().allExams;

    if (exams.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Overall Performance', style: AppTextStyle.style16Bold),
        16.verticalSpace,
        SizedBox(
          height: 260.h,
          child: LineChart(
            LineChartData(
              minY: 0,
              maxY: 100,
              lineBarsData: [
                LineChartBarData(
                  isCurved: true,
                  barWidth: 3,
                  spots: exams
                      .asMap()
                      .entries
                      .map(
                        (e) => FlSpot(
                          e.key.toDouble(),
                          (e.value.score ?? 0).toDouble(),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

enum AnalysisViewMode { overall, exam }

class ExamAnalysisScreen extends StatelessWidget {
  const ExamAnalysisScreen({super.key, required this.exam});

  final Exam exam;

  @override
  Widget build(BuildContext context) {
    final List<AnalysisDataModel>? examCategories = exam.categories;

    return Scaffold(
      appBar: CustomAppBar(title: 'Exam ${exam.examNo}'),
      body: examCategories == null || examCategories.isEmpty
          ? Center(
              child: Text(
                'No analysis data found for this exam.',
                style: AppTextStyle.style16Bold.copyWith(
                  color: AppColors.forthColor,
                ),
              ),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  15.verticalSpace,
                  Center(
                    child: Text(
                      'Score: ${exam.score ?? 0} / 100',
                      style: AppTextStyle.style20W600,
                    ),
                  ),
                  30.verticalSpace,
                  const Divider(color: AppColors.darkGreyColor),
                  20.verticalSpace,

                  30.verticalSpace,

                  /// Chart
                  PerformanceChart(data: examCategories),

                  30.verticalSpace,

                  /// Detailed Table
                  buildDetailedTable(context, examCategories),
                ],
              ),
            ),
    );
  }
}
  // return ListView.builder(
  //                     shrinkWrap: true,
  //                     physics: const NeverScrollableScrollPhysics(),
  //                     itemCount: exams.length,
  //                     itemBuilder: (context, index) {
  //                       final exam = exams[index];
  //                       return InkWell(
  //                         onTap: () => context.pushNamed(
  //                           AppRoutes.examAnalysisScreen,
  //                           arguments: exam,
  //                         ),
  //                         child: Padding(
  //                           padding: EdgeInsets.only(bottom: 16.h),
  //                           child: ExamScoreCard(exam: exam),
  //                         ),
  //                       );
  //                     },
  //                   );