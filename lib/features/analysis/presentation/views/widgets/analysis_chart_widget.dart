import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';
import 'package:smle/features/analysis/data/model/analysis_model.dart';

Widget buildDetailedTable(
  BuildContext context,
  final List<AnalysisDataModel> data,
) {
  return Card(
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    clipBehavior: Clip.antiAlias,
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: WidgetStateProperty.all(AppColors.greyColor),
        headingTextStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          color: AppColors.greyColor,
        ),
        columns: [
          DataColumn(
            label: Text(
              'Category',
              style: AppTextStyle.style14W700.copyWith(
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
              style: AppTextStyle.style14W700.copyWith(
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
              style: AppTextStyle.style14W700.copyWith(
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
                  style: AppTextStyle.style14W500.copyWith(
                    color: AppColors.thirdColor,
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
                  style: AppTextStyle.style14W500.copyWith(
                    color: AppColors.thirdColor,
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
                  style: AppTextStyle.style14W500.copyWith(
                    color: AppColors.thirdColor,
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
    ),
  );
}

class PerformanceChart extends StatelessWidget {
  const PerformanceChart({super.key, required this.data});
  final List<AnalysisDataModel> data;

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
                _buildLine(
                  color: Colors.teal,
                  spots: examSpots,
                  shadow: Colors.teal.withAlpha(55),
                ),
                _buildLine(
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
                        meta: meta,
                        space: 8.0,
                        child: Text(
                          label.length > 14
                              ? '${label.substring(0, 14)}...'
                              : label,
                          style: AppTextStyle.style16Bold.copyWith(
                            color: AppColors.thirdColor,
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
      ],
    );
  }

  LineChartBarData _buildLine({
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
