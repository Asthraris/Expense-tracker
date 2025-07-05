part of 'get_tran_bloc.dart';

sealed class GetTranEvent extends Equatable {
  const GetTranEvent();

  @override
  List<Object> get props => [];
}

//check spelling
class GetTransactions extends GetTranEvent {}
