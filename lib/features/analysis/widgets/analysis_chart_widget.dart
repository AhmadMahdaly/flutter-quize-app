import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:smle/features/analysis/data/model/analysis_model.dart';

class PerformanceChart extends StatelessWidget {
  final List<Analysis> data;

  const PerformanceChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        lineBarsData: [
          _buildLine(
            color: Colors.teal,
            spots: data.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.examPercentage!)).toList(),
          ),
          _buildLine(
            color: Colors.blue,
            spots: data.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.averagePercentage!)).toList(),
          ),
        ],
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true, interval: 10),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, _) {
                int index = value.toInt();
                if (index < 0 || index >= data.length) return const SizedBox.shrink();
                return Transform.rotate(
                  angle: -0.4,
                  child: Text(
                    data[index].category!,
                    style: const TextStyle(fontSize: 10),
                  ),
                );
              },
            ),
          ),
        ),
        minY: 0,
        maxY: 100,
        gridData: FlGridData(show: true),
        borderData: FlBorderData(show: true),
      ),
    );
  }

  LineChartBarData _buildLine({
    required Color color,
    required List<FlSpot> spots,
  }) {
    return LineChartBarData(
      isCurved: true,
      color: color,
      barWidth: 3,
      dotData: FlDotData(show: true),
      spots: spots,
    );
  }
}