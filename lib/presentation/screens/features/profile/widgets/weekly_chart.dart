import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rayoflite/core/theme/appcolors.dart';
import 'package:rayoflite/core/theme/themeProvider.dart';
import 'package:rayoflite/presentation/screens/features/screen_time/data/ScreenTimeProvider.dart';

class WeeklyChart extends StatelessWidget {
  const WeeklyChart({super.key});

  int _dayToIndex(String day) {
    const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return days.indexOf(day);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    final provider = context.watch<ScreenTimeProvider>();

    if (provider.isLoading) {
      return const SizedBox(
        height: 300,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    // Prepare spots — flat line if no data yet
    List<FlSpot> spots;
    if (provider.weeklyData.isEmpty) {
      spots = List.generate(7, (i) => FlSpot(i.toDouble(), 0));
    } else {
      spots = provider.weeklyData.map((data) {
        return FlSpot(_dayToIndex(data.day).toDouble(), data.hours);
      }).toList();
      spots.sort((a, b) => a.x.compareTo(b.x));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ─── Section label ───
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Icon(
                Icons.access_time_rounded,
                size: 15,
                color: AppColors.getMonoTextMuted(isDark),
              ),
              const SizedBox(width: 6),
              Text(
                'Time Spent This Week',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.getMonoTextMuted(isDark),
                  letterSpacing: 0.4,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // ─── Chart ───
        SizedBox(
          height: 260,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: LineChart(
              LineChartData(
                minY: 0,
                maxY: 24,
                minX: 0,
                maxX: 6,
                borderData: FlBorderData(
                  show: true,
                  border: Border(
                    bottom: BorderSide(
                      color: isDark ? Colors.white10 : Colors.black12,
                    ),
                    left: BorderSide(
                      color: isDark ? Colors.white10 : Colors.black12,
                    ),
                  ),
                ),
                gridData: FlGridData(
                  show: false,
                  drawVerticalLine: false,
                  horizontalInterval: 6,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: isDark ? Colors.white10 : Colors.black12,
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) {
                        const days = [
                          'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'
                        ];
                        if (value < 0 ||
                            value >= days.length ||
                            value != value.toInt()) {
                          return const SizedBox();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            days[value.toInt()],
                            style: TextStyle(
                              fontSize: 10,
                              color: AppColors.getTextPrimaryColor(isDark)
                                  .withOpacity(0.5),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 35,
                      getTitlesWidget: (val, meta) => Text(
                        '${val.toInt()}h',
                        style: TextStyle(
                          fontSize: 10,
                          color: AppColors.getTextPrimaryColor(isDark)
                              .withOpacity(0.5),
                        ),
                      ),
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: provider.weeklyData.isEmpty
                        ? AppColors.getPrimary(isDark).withOpacity(0.2)
                        : AppColors.getPrimary(isDark),
                    barWidth: 3,
                    dotData: FlDotData(show: provider.weeklyData.isNotEmpty),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppColors.getPrimary(isDark).withOpacity(0.05),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
