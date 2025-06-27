import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:poorometer/screens/home/views/main_src.dart';
import 'package:poorometer/screens/home/views/stats-src.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  var widgetList = [MainScreen(), statsScreen()];
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          setState(() {
            if (value > 1) log("Hacker hai bhai Hacker!");
            index = value;
          });
        },

        backgroundColor: Theme.of(context).colorScheme.tertiary,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.assessment), label: "Stats"),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () {},
        child: Icon(Icons.add),
      ),
      body: widgetList[index],
    );
  }
}
