import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:expense_repository/expense_repository.dart';

class WeekChartScreen extends StatelessWidget {
  final List<Transaction> transactions;

  const WeekChartScreen(this.transactions, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: WeekChart(transactions),
        ),
      ),
    );
  }
}

class WeekChart extends StatelessWidget {
  final List<Transaction> weekTrans;

  const WeekChart(this.weekTrans, {super.key});

  @override
  Widget build(BuildContext context) {
    final Map<int, double> credits = {for (var i = 0; i < 7; i++) i: 0};
    final Map<int, double> debits = {for (var i = 0; i < 7; i++) i: 0};

    for (var transaction in weekTrans) {
      final weekday = transaction.date.weekday; // Monday = 1, Sunday = 7
      final index = weekday - 1; // 0-based index: 0 for Mon, 6 for Sun

      if (index >= 0 && index < 7) {
        if (transaction.amount >= 0) {
          credits[index] =
              (credits[index] ?? 0) + transaction.amount.toDouble();
        } else {
          debits[index] =
              (debits[index] ?? 0) + transaction.amount.abs().toDouble();
        }
      }
    }

    final List<double> creditsWeekly = List.generate(7, (i) => credits[i] ?? 0);
    final List<double> debitsWeekly = List.generate(7, (i) => debits[i] ?? 0);
    final allValues = [...creditsWeekly, ...debitsWeekly];

    double maxAmount = (allValues.isNotEmpty)
        ? allValues.reduce((a, b) => a > b ? a : b)
        : 0;
    maxAmount = (maxAmount * 1.2).ceilToDouble();

    final interval = getInterval(maxAmount);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: BarChart(
            BarChartData(
              maxY: maxAmount,
              barGroups: List.generate(7, (index) {
                return BarChartGroupData(
                  x: index,
                  barsSpace: 1,
                  barRods: [
                    BarChartRodData(
                      toY: creditsWeekly[index],
                      width: 15,
                      borderRadius: BorderRadius.circular(4),
                      color: const Color.fromARGB(255, 138, 255, 122),
                    ),
                    BarChartRodData(
                      toY: debitsWeekly[index],
                      width: 15,
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
              gridData: FlGridData(show: false),
              borderData: FlBorderData(show: false),
            ),
          ),
        ),
      ],
    );
  }

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

  double getInterval(double maxY) {
    if (maxY <= 1000) return 200;
    if (maxY <= 3000) return 500;
    if (maxY <= 6000) return 1000;
    if (maxY <= 10000) return 2000;
    if (maxY <= 20000) return 5000;
    return 10000;
  }
}
