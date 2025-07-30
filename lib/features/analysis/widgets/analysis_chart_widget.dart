import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:smle/features/analysis/data/model/analysis_model.dart';

class PerformanceChart extends StatelessWidget {
  const PerformanceChart({super.key, required this.data});
  final List<Analysis> data;

  // Ensure value is valid for plotting
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

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: data.length * 50, // adjust width per data point
        height: 300,
        child: LineChart(
          LineChartData(
            minY: 0,
            maxY: 100,
            minX: 0,
            maxX: data.length.toDouble() - 1,
            gridData: const FlGridData(show: true),
            borderData: FlBorderData(show: true),
            lineBarsData: [
              _buildLine(color: Colors.teal, spots: examSpots),
              _buildLine(color: Colors.blue, spots: averageSpots),
            ],
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 5,
                  reservedSize: 40,
                  getTitlesWidget: (value, _) => Text(
                    value.toInt().toString(),
                    style: const TextStyle(fontSize: 10),
                  ),
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
                  getTitlesWidget: (value, _) {
                    int index = value.toInt();
                    if (index < 0 || index >= data.length) {
                      return const SizedBox.shrink();
                    }
                    final label = data[index].category ?? '';
                    return Transform.rotate(
                      angle: -0.4,
                      child: Text(
                        label.length > 8 ? '${label.substring(0, 8)}...' : label,
                        style: const TextStyle(fontSize: 10),
                      ),
                    );
                  },
                ),
              ),
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
          ),
        ),
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
      dotData: const FlDotData(show: true),
      belowBarData: BarAreaData(show: false),
      spots: spots,
    );
  }
}
