import 'package:expense_repository/expense_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poorometer/screens/home/views/blocs/get_tran_BLOC/get_tran_bloc.dart';
import 'package:poorometer/screens/home/views/home_src.dart';

class MyAppView extends StatelessWidget {
  const MyAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Pooro-meter",
      theme: ThemeData(
        colorScheme: ColorScheme.dark(
          //change this theme app
          surface: Color(0xFF000000),
          onSurface: Color(0xFF988686),
          primary: Color(0xFFD1D0D0),
          secondary: Color(0xFF988686),
          tertiary: Color(0xFF5C4E4E),
        ),
      ),
      home: BlocProvider(
        create: (context) =>
            GetTranBloc(FirebaseExpenseRepo())..add(GetTransactions()),
        child: const HomeScreen(),
      ),
    );
  }
}
