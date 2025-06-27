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
          surface: Color(0xFF181C14),
          onSurface: Color(0xFFEAEFEF),
          primary: Color(0xFFECDFCC),
          secondary: Color(0xFF697565),
          tertiary: Color(0xFF3C3D37),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
