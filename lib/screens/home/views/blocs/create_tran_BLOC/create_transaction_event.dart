part of 'create_transaction_bloc.dart';

sealed class CreateTransactionEvent extends Equatable {
  const CreateTransactionEvent();

  @override
  List<Object> get props => [];
}

class CreateTransaction extends CreateTransactionEvent {
  final Transaction trans;

  const CreateTransaction(this.trans);

  @override
  List<Object> get props => [trans];
}
