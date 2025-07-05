import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:expense_repository/expense_repository.dart';

part 'get_tran_event.dart';
part 'get_tran_state.dart';

class GetTranBloc extends Bloc<GetTranEvent, GetTranState> {
  ExpenseRepository expenseRepository;

  GetTranBloc(this.expenseRepository) : super(GetTranInitial()) {
    on<GetTransactions>((event, emit) async {
      emit(GetTranLoading());
      try {
        final userId = FirebaseAuth.instance.currentUser?.uid;

        if (userId == null) {
          emit(GetTranFailure());
          log("User not logged in !!!");
          return;
        }
        final expenses = await expenseRepository.getTransaction(userId: userId);
        emit(GetTranSuccess(expenses));
      } catch (e) {
        log("Fetch error: $e"); // Optional: log errors
        emit(GetTranFailure());
      }
    });
  }
}
