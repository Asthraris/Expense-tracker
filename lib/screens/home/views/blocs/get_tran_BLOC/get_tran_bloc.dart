import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:expense_repository/expense_repository.dart';

part 'get_tran_event.dart';
part 'get_tran_state.dart';

class GetTranBloc extends Bloc<GetTranEvent, GetTranState> {
  ExpenseRepository expenseRepository;

  GetTranBloc(this.expenseRepository) : super(GetTranInitial()) {
    on<GetTransactions>((event, emit) async {
      emit(GetTranLoading());
      try {
        final expenses = await expenseRepository.getTransaction();
        log("Fetched ${expenses.length} transactions"); // Debug log
        emit(GetTranSuccess(expenses));
      } catch (e) {
        log("Fetch error: $e"); // Optional: log errors
        emit(GetTranFailure());
      }
    });
  }
}
