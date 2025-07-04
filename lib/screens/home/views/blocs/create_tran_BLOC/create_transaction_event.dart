part of 'create_transaction_bloc.dart';

sealed class CreateTransactionEvent extends Equatable {
  const CreateTransactionEvent();

  @override
  List<Object> get props => [];
}

class CreateTransaction extends CreateTransactionEvent {
  final Transaction transaction;

  const CreateTransaction({required this.transaction});

  @override
  List<Object> get props => [transaction];
}
