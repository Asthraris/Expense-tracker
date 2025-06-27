import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class WeekChart extends StatefulWidget {
  const WeekChart({super.key});

  @override
  State<WeekChart> createState() => _WeekChartState();
}

class _WeekChartState extends State<WeekChart> {
  @override
  Widget build(BuildContext context) {
    return BarChart(mainBarData());
  }
}

BarChartData mainBarData() {
  return BarChartData(
    titlesData: FlTitlesData(
      show: true,
      //removes line outside bar data
      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: false,
          reservedSize: 38,
          getTitlesWidget: getTiles(),
        ),
      ),
    ),
  );
}

Widget getTiles(double value, TitleMeta meta) {
  const my_bar_style = TextStyle(color: Colors.white, fontSize: 14);
  Widget my_text;
  switch (value.toInt()) {
    case 0:
      my_text = const Text("01", style: my_bar_style);
      break;
    default:
  }
  return text;
}
