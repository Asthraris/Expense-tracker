import 'package:flutter/material.dart';
import 'package:poorometer/screens/home/views/weely_chart.dart';

class statsScreen extends StatelessWidget {
  const statsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        child: Column(
          children: [
            Text(
              "Usage Stats",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width / 1.5,
              // color: Colors.red,
              child: WeekChart(),
            ),
          ],
        ),
      ),
    );
  }
}
