import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class WeekChartScreen extends StatelessWidget {
  const WeekChartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(padding: EdgeInsets.all(16), child: WeekChart()),
      ),
    );
  }
}

class WeekChart extends StatelessWidget {
  const WeekChart({super.key});

  // REAL DATA
  final List<double> credits_weekly = const [400, 10000, 500, 200, 300, 40, 30];
  final List<double> debits_weekly = const [
    2000,
    1500,
    1000,
    1800,
    2200,
    1200,
    1600,
  ];

  @override
  Widget build(BuildContext context) {
    final allValues = [...credits_weekly, ...debits_weekly];
    final maxY = getMaxY(allValues);
    final interval = getInterval(maxY);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: BarChart(
            BarChartData(
              maxY: maxY,
              barGroups: List.generate(7, (index) {
                return BarChartGroupData(
                  x: index,
                  barsSpace: 3,
                  barRods: [
                    BarChartRodData(
                      toY: credits_weekly[index],
                      width: 8,
                      borderRadius: BorderRadius.circular(4),
                      color: const Color.fromARGB(255, 138, 255, 122),
                    ),
                    BarChartRodData(
                      toY: debits_weekly[index],
                      width: 8,
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.redAccent.shade100,
                    ),
                  ],
                );
              }),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: interval,
                    reservedSize: 48,
                    getTitlesWidget: leftTitles,
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 32,
                    getTitlesWidget: bottomTitles,
                  ),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              gridData: FlGridData(show: false), // Remove background grid
              borderData: FlBorderData(show: false),
            ),
          ),
        ),
      ],
    );
  }

  // Rs. scale on the left
  Widget leftTitles(double value, TitleMeta meta) {
    return SideTitleWidget(
      meta: meta,
      space: 0,
      child: Text(
        '₹ ${value.toInt()}',
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }

  // Days on the bottom
  Widget bottomTitles(double value, TitleMeta meta) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final index = value.toInt();
    return SideTitleWidget(
      meta: meta,
      space: 5,
      child: Text(
        index >= 0 && index < days.length ? days[index] : '',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Max Y axis value rounded nicely
  double getMaxY(List<double> values) {
    final max = values.reduce((a, b) => a > b ? a : b);
    return (max * 1.2 / 1000).ceil() * 1000; // Add headroom & round
  }

  // Interval for Y axis
  double getInterval(double maxY) {
    if (maxY <= 1000) return 200;
    if (maxY <= 3000) return 500;
    if (maxY <= 6000) return 1000;
    if (maxY <= 10000) return 2000;
    if (maxY <= 20000) return 5000;
    return 10000;
  }
}
