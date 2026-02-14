import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rayoflite/core/theme/appcolors.dart';
import 'package:rayoflite/core/theme/themeProvider.dart';

class WeeklyChart extends StatelessWidget {
  const WeeklyChart({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;

    return SizedBox(
      height: 300,
      child: LineChart(
        LineChartData(
          borderData: FlBorderData(show: false),
          gridData: FlGridData(show: true),
          titlesData: FlTitlesData(show: true),
          lineBarsData: [
            LineChartBarData(
              color: AppColors.getPrimary(isDark),
              isCurved: true,
              dotData: FlDotData(show: true),
              spots: const [
                FlSpot(0, 45),
                FlSpot(1, 30),
                FlSpot(2, 85),
                FlSpot(3, 60),
                FlSpot(4, 58),
                FlSpot(5, 98),
                FlSpot(6, 50),
              ],
            ),
          ],
        ),
      ),
    );
  }
}