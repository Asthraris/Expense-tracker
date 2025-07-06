import 'dart:developer';

import 'package:expense_repository/expense_repository.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poorometer/screens/home/views/components/add_exp.dart';
import 'package:poorometer/screens/blocs/create_tran_BLOC/create_transaction_bloc.dart';
import 'package:poorometer/screens/blocs/get_tran_BLOC/get_tran_bloc.dart';
import 'package:poorometer/screens/home/views/main_src.dart';
import 'package:poorometer/screens/home/views/stats_src.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int selectedCard = 0;
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetTranBloc, GetTranState>(
      builder: (context, state) {
        if (state is GetTranSuccess) {
          return Scaffold(
            // appBar: AppBar(),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: index,
              onTap: (value) {
                setState(() {
                  if (value > 1) log("Hacker hai bhai Hacker!");
                  index = value;
                });
              },

              backgroundColor: Theme.of(context).colorScheme.tertiary,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              selectedItemColor: const Color.fromARGB(255, 81, 197, 255),
              unselectedItemColor: const Color.fromARGB(255, 152, 152, 152),
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
                BottomNavigationBarItem(
                  icon: Icon(Icons.assessment),
                  label: "Stats",
                ),
              ],
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: FloatingActionButton(
              shape: const CircleBorder(),
              onPressed: () async {
                final isSuccess = await showModalBottomSheet<bool>(
                  context: context,
                  backgroundColor: Colors.transparent,
                  isScrollControlled:
                      false, // set to true if you want full-screen behavior
                  builder: (_) {
                    return BlocProvider(
                      create: (_) =>
                          CreateTransactionBloc(FirebaseExpenseRepo()),
                      child: AddExpense(selectedCard),
                    );
                  },
                );
                if (isSuccess == true) {
                  context.read<GetTranBloc>().add(GetTransactions());
                }
              },
              child: Icon(Icons.add),
            ),
            body: index == 0
                ? MainScreen(state.transactions, selectedCard, (newCard) {
                    setState(() {
                      selectedCard = newCard;
                    });
                  })
                : statsScreen(state.transactions),
          );
        } else {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}
