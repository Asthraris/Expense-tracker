part of 'get_tran_bloc.dart';

sealed class GetTranState extends Equatable {
  const GetTranState();

  @override
  List<Object> get props => [];
}

final class GetTranInitial extends GetTranState {}

final class GetTranFailure extends GetTranState {}

final class GetTranLoading extends GetTranState {}

final class GetTranSuccess extends GetTranState {
  final List<Transaction> transactions;

  const GetTranSuccess(this.transactions);

  @override
  List<Object> get props => [transactions];
}
