import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expense_repository/expense_repository.dart';

part 'create_transaction_event.dart';
part 'create_transaction_state.dart';

class CreateTransactionBloc
    extends Bloc<CreateTransactionEvent, CreateTransactionState> {
  ExpenseRepository expenseRepository;

  CreateTransactionBloc(this.expenseRepository)
    : super(CreateTransactionInitial()) {
    on<CreateTransaction>((event, emit) async {
      emit(CreateTransactionLoading());
      try {
        await expenseRepository.createTransaction(event.transaction);

        emit(CreateTransactionSuccess());
      } catch (e) {
        emit(CreateTransactionFailure());
      }
    });
  }
}
