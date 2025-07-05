part of 'create_transaction_bloc.dart';

sealed class CreateTransactionState extends Equatable {
  const CreateTransactionState();

  @override
  List<Object> get props => [];
}

final class CreateTransactionInitial extends CreateTransactionState {}

final class CreateTransactionFailure extends CreateTransactionState {}

final class CreateTransactionLoading extends CreateTransactionState {}

final class CreateTransactionSuccess extends CreateTransactionState {}
