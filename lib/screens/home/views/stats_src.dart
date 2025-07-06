import 'package:flutter/material.dart';
import 'package:poorometer/screens/home/views/components/weely_chart.dart';
import 'package:expense_repository/expense_repository.dart';

class statsScreen extends StatelessWidget {
  final List<Transaction> transactions;

  const statsScreen(this.transactions, {super.key});

  @override
  Widget build(BuildContext context) {
    final thisWeekTransactions = getWeeklyTrans(transactions);
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
              child: WeekChart(thisWeekTransactions),
            ),
          ],
        ),
      ),
    );
  }

  List<Transaction> getWeeklyTrans(List<Transaction> transactions) {
    DateTime now = DateTime.now();
    int currentWeekday = now.weekday;
    DateTime startofWeek = now.subtract(Duration(days: currentWeekday - 1));
    DateTime endofWeek = startofWeek.add(const Duration(days: 6));
    //removing Time from datetime
    startofWeek = DateTime(
      startofWeek.year,
      startofWeek.month,
      startofWeek.day,
    );
    endofWeek = DateTime(
      endofWeek.year,
      endofWeek.month,
      endofWeek.day,
      23,
      59,
      59,
    );

    return transactions.where((transaction) {
      DateTime date = transaction.date;
      return date.isAfter(startofWeek.subtract(const Duration(seconds: 1))) &&
          date.isBefore(endofWeek.add(const Duration(seconds: 1)));
    }).toList();
  }
}
