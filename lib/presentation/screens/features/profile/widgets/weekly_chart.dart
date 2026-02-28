import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rayoflite/core/theme/appcolors.dart';
import 'package:rayoflite/core/theme/themeProvider.dart';
import 'package:rayoflite/presentation/screens/features/screen_time/data/ScreenTimeProvider.dart';

class WeeklyChart extends StatelessWidget {
  const WeeklyChart({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    final provider = context.watch<ScreenTimeProvider>();

    return SizedBox(
      height: 280,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: LineChart(
          LineChartData(
            minY: 0,
            maxY: 24,
            minX: 0,
            maxX: 6,
            borderData: FlBorderData(show: false),

            // 🔹 Grid always visible
            gridData: FlGridData(
              show: true,
              horizontalInterval: 4,
              getDrawingHorizontalLine: (value) {
                return FlLine(
                  color:
                      isDark
                          ? Colors.white.withOpacity(0.08)
                          : Colors.black.withOpacity(0.05),
                  strokeWidth: 1,
                );
              },
              getDrawingVerticalLine: (value) {
                return FlLine(
                  color:
                      isDark
                          ? Colors.white.withOpacity(0.05)
                          : Colors.black.withOpacity(0.03),
                  strokeWidth: 1,
                );
              },
            ),

            // 🔹 Axis always visible
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 4,
                  reservedSize: 32,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      "${value.toInt()}h",
                      style: TextStyle(
                        fontSize: 10,
                        color: AppColors.getTextPrimaryColor(isDark),
                      ),
                    );
                  },
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1, // 🔥 IMPORTANT
                  reservedSize: 30,
                  getTitlesWidget: (value, meta) {
                    const days = [
                      'Sun',
                      'Mon',
                      'Tue',
                      'Wed',
                      'Thu',
                      'Fri',
                      'Sat',
                    ];

                    if (value % 1 != 0) {
                      return const SizedBox(); // avoid fractional labels
                    }

                    final index = value.toInt();
                    if (index < 0 || index > 6) {
                      return const SizedBox();
                    }

                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        days[index],
                        style: const TextStyle(fontSize: 12),
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

            // 🔥 KEY CHANGE HERE
            lineBarsData: [
              LineChartBarData(
                isCurved: true,
                color: AppColors.getPrimary(isDark),
                barWidth: 3,

                // 🔹 If no data → hide dots
                dotData: FlDotData(show: provider.weeklyData.isNotEmpty),

                // 🔹 If no data → hide area
                belowBarData: BarAreaData(
                  show: provider.weeklyData.isNotEmpty,
                  color: AppColors.getPrimary(isDark).withOpacity(0.15),
                ),

                // 🔹 If empty → empty spots
                spots:
                    provider.weeklyData.isNotEmpty
                        ? provider.weeklyData
                            .asMap()
                            .entries
                            .map((e) => FlSpot(e.key.toDouble(), e.value.hours))
                            .toList()
                        : [],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
