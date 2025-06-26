import 'package:flutter/material.dart';
import 'package:poorometer/screens/home/views/home_src.dart';

class MyAppView extends StatelessWidget {
  const MyAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Pooro-meter",
      theme: ThemeData(
        colorScheme: ColorScheme.dark(
          //change this theme app
          surface: Color(0xFF333446),
          onSurface: Color(0xFFEAEFEF),
          primary: Color(0xFF7F8CAA),
          secondary: Color(0xFFB8CFCE),
          tertiary: Color(0xFFEAEFEF),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
