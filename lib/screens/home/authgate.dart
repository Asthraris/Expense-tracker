import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:expense_repository/expense_repository.dart';

import '../blocs/get_tran_BLOC/get_tran_bloc.dart';
import 'views/login_src.dart';
import 'views/home_src.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(), // Persistent Auth
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          // User is logged in → HomeScreen
          return BlocProvider(
            create: (context) =>
                GetTranBloc(FirebaseExpenseRepo())..add(GetTransactions()),
            child: const HomeScreen(),
          );
        } else {
          // Not logged in → LoginScreen
          return LoginScreen(
            onLoginSuccess: () {
              // Force rebuild after login (optional, usually not needed here)
            },
          );
        }
      },
    );
  }
}
