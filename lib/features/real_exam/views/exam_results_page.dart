import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:smle/core/di.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/helpers/extensions.dart';
import 'package:smle/core/routing/routes.dart';
import 'package:smle/core/shared_widgets/custom_app_bar.dart';
import 'package:smle/core/shared_widgets/custom_primary_button.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';
import 'package:smle/features/real_exam/cubit/real_exam_cubit.dart';
import 'package:smle/features/real_exam/data/model/finish_analysis_exam.dart';

class ExamResultsPage extends StatelessWidget {
  const ExamResultsPage({super.key, required this.results});
  final FinishAnalysisExamModel results;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(canBack: false, title: 'Exam Analysis'),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Text(
                      'Your Final Score',
                      style: interBold.copyWith(
                        color: AppColors.forthColor,
                        fontSize: SizeConfig.responsiveValue(
                          phone: 16.sp,
                          tablet: 20.sp,
                        ),
                      ),
                    ),
                    8.verticalSpace,
                    Text(
                      '${results.totalScore}',
                      style: interBold.copyWith(
                        color: AppColors.primaryColor,
                        fontSize: SizeConfig.responsiveValue(
                          phone: 24.sp,
                          tablet: 28.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            24.verticalSpace,

            Text(
              'Performance Breakdown',
              style: interBold.copyWith(
                color: AppColors.forthColor,
                fontSize: SizeConfig.responsiveValue(
                  phone: 16.sp,
                  tablet: 20.sp,
                ),
              ),
            ),
            16.verticalSpace,

            PerformanceChart(data: results.data),
            24.verticalSpace,

            _buildDetailedTable(context, results.data),
            32.verticalSpace,
            CustomPrimaryButton(
              text: 'Back to Home',
              onPressed: () {
                getIt<RealExamCubit>().resetExam();
                context.pushReplacementNamed(Routes.mainLayoutScreen);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailedTable(BuildContext context, List<ScoreData> data) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: DataTable(
        headingRowColor: WidgetStateProperty.all(Colors.grey.shade200),
        headingTextStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        columns: [
          DataColumn(
            label: Text(
              'Category',
              style: interMedium.copyWith(
                color: AppColors.forthColor,
                fontSize: SizeConfig.responsiveValue(
                  phone: 14.sp,
                  tablet: 18.sp,
                ),
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'Your %',
              style: interMedium.copyWith(
                color: AppColors.forthColor,
                fontSize: SizeConfig.responsiveValue(
                  phone: 14.sp,
                  tablet: 18.sp,
                ),
              ),
            ),
            numeric: true,
          ),
          DataColumn(
            label: Text(
              'Average %',
              style: interMedium.copyWith(
                color: AppColors.forthColor,
                fontSize: SizeConfig.responsiveValue(
                  phone: 14.sp,
                  tablet: 18.sp,
                ),
              ),
            ),
            numeric: true,
          ),
        ],
        rows: data.map((item) {
          return DataRow(
            cells: [
              DataCell(
                Text(
                  item.category,
                  style: interRegular.copyWith(
                    color: AppColors.forthColor,
                    fontSize: SizeConfig.responsiveValue(
                      phone: 12.sp,
                      tablet: 16.sp,
                    ),
                  ),
                ),
              ),
              DataCell(
                Text(
                  '${item.examPercentage.toStringAsFixed(1)}%',
                  style: interRegular.copyWith(
                    color: AppColors.forthColor,
                    fontSize: SizeConfig.responsiveValue(
                      phone: 12.sp,
                      tablet: 16.sp,
                    ),
                  ),
                ),
              ),
              DataCell(
                Text(
                  '${item.averagePercentage.toStringAsFixed(1)}%',
                  style: interRegular.copyWith(
                    color: AppColors.forthColor,
                    fontSize: SizeConfig.responsiveValue(
                      phone: 12.sp,
                      tablet: 16.sp,
                    ),
                  ),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class PerformanceChart extends StatelessWidget {
  const PerformanceChart({super.key, required this.data});
  final List<ScoreData> data;

  double _safeScore(double? value) {
    if (value == null || value.isNaN || value.isInfinite) return 0.0;
    return value;
  }

  @override
  Widget build(BuildContext context) {
    final examSpots = <FlSpot>[];
    final averageSpots = <FlSpot>[];

    for (int i = 0; i < data.length; i++) {
      final exam = _safeScore(data[i].examPercentage);
      final avg = _safeScore(data[i].averagePercentage);
      examSpots.add(FlSpot(i.toDouble(), exam));
      averageSpots.add(FlSpot(i.toDouble(), avg));
    }

    return Column(
      children: [
        SizedBox(
          height: 300.h,
          child: LineChart(
            LineChartData(
              minY: 0,
              maxY: 100,
              minX: 0,
              maxX: (data.length - 1).toDouble(),
              gridData: FlGridData(
                show: true,
                getDrawingHorizontalLine: (value) =>
                    const FlLine(color: Colors.black12, strokeWidth: 1),
                getDrawingVerticalLine: (value) =>
                    const FlLine(color: Colors.black12, strokeWidth: 1),
              ),
              borderData: FlBorderData(
                show: true,
                border: Border.all(color: Colors.black26),
              ),
              lineBarsData: [
                _lineWidget(
                  color: Colors.teal,
                  spots: examSpots,
                  shadow: Colors.teal.withAlpha(55),
                ),
                _lineWidget(
                  color: Colors.blueAccent,
                  spots: averageSpots,
                  shadow: Colors.blueAccent.withAlpha(55),
                ),
              ],
              titlesData: FlTitlesData(
                leftTitles: const AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 20,
                    reservedSize: 40,
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 1,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) {
                      final int index = value.toInt();
                      if (index < 0 || index >= data.length) {
                        return const SizedBox.shrink();
                      }
                      final label = data[index].category;
                      return SideTitleWidget(
                        axisSide: meta.axisSide,
                        space: 8.0,
                        child: Text(
                          label.length > 14
                              ? '${label.substring(0, 14)}...'
                              : label,
                          style: interBold.copyWith(
                            color: AppColors.forthColor,
                            fontSize: SizeConfig.responsiveValue(
                              phone: 10.sp,
                              tablet: 14.sp,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
            ),
          ),
        ),
        12.verticalSpace,
        _buildLegend(context),
      ],
    );
  }

  Widget _buildLegend(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _legendItem(Colors.teal, 'Your Performance'),
        20.horizontalSpace,
        _legendItem(Colors.blueAccent, 'Average Performance'),
      ],
    );
  }

  Widget _legendItem(Color color, String text) {
    return Row(
      children: [
        Container(width: 16.w, height: 16.h, color: color),
        8.horizontalSpace,
        Text(
          text,
          style: interRegular.copyWith(
            color: AppColors.iconColorGray,
            fontSize: SizeConfig.responsiveValue(phone: 14.sp, tablet: 18.sp),
          ),
        ),
      ],
    );
  }

  LineChartBarData _lineWidget({
    required Color color,
    required List<FlSpot> spots,
    Color? shadow,
  }) {
    return LineChartBarData(
      isCurved: true,
      color: color,
      barWidth: 2.w,
      dotData: const FlDotData(show: true),
      belowBarData: BarAreaData(show: false),
      spots: spots,
      shadow: Shadow(
        color: shadow ?? Colors.transparent,
        blurRadius: 8,
        offset: const Offset(0, 4),
      ),
    );
  }
}
